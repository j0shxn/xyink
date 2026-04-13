/*
                              XYINK v0.6-alpha
    XY Inverse Kinematics Program with Orthogonality Error Compensation
    Author: Bugra Coskun
    
    TODO:
        * Find the continuity issues in the program and fix them
        * Add matrix to matrix multiplication
        * Add euler angles to orientation matrix function
        * Add tilt compensation feature
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <complex.h>
#include <string.h>

bool verbose = false;
bool symmetric_roots = false;
bool nosane_roots = false;
bool default_xy = true;
bool illegal_input_error = false;
const double PI2 = 2*M_PI;
const char version_text[] = "v0.6-alpha";

double dotp(double v[], double u[])
{ // Calculate the dot product of the 
    double sum = 0;

    for (int i = 0 ; i < 3 ; i++) sum = sum + v[i]*u[i];
    return sum;
}

void crossp(double *pv, double *pu, double *pr)
{
    // Get the first element address of two arrays and then write the
    // resulting cross product vector to the adress of the third argument
    // Because that C can't output arrays, pointers are used to read and
    // write the array values in the global scope
    double v[3], u[3], r[3];
    int i;
    // Get the array values from dereferencing the pointers
    for (i = 0 ; i < 3 ; i++)
    {
        // Increase the address value of the pointers by i and get the value
        // stored in it by deferencing the address
        v[i] = *(pv + i);
        u[i] = *(pu + i);
    }

    // Cross product calculation
    r[0] = v[1]*u[2] - v[2]*u[1];
    r[1] = v[2]*u[0] - v[0]*u[2];
    r[2] = v[0]*u[1] - v[1]*u[0];

    // Write the result to the array indexed by the address of the 
    // first element of it
    for (i = 0 ; i < 3 ; i++)
    {
        *(pr + i) = r[i];
    }
}

void sp2ca(double azr, double elr, double *pca)
{
    // azr: Azimuth angle in radians
    // elr: Elevation angle in radians
    // pca: Cartesian vector in global scope
    double ca[3];

    // Calculate the cartesian vector
    ca[0] = cos(elr) * cos(azr);
    ca[1] = cos(elr) * sin(azr);
    ca[2] = sin(elr);

    // Write the cartesian vector to the address pointed by array pointer
    for (int i = 0 ; i < 3 ; i++) *(pca + i) = ca[i];
}

double deg2rad(double deg) 
{ // Convert degrees to radians
    return deg*((2*M_PI)/360.0);
}

double rad2deg(double rad)
{ // Convert radians to degrees
        return rad*(360.0/(2*M_PI));
}

double veclen(double v[3])
{ // Calculate the length of a 3D vector !!!!!!!!!!!! WARNING BUGGY
    double len = sqrt(pow(v[0],2) + pow(v[1],2) + pow(v[2],2));
    return len;
}

void matmul(double *pmat, double *pvec, double *presv)
{ // *mat is 9 element array *vec is 3 element array
    int i; int j;
    for (i=0;i<3;i++) *(presv + i) = 0;
    
    // Use two loops to go through the matrix and the vector
    // multiply and add the elements together
    for (j = 0 ; j < 3 ; j++)
    {
        for (i=0;i<3;i++)
        {
            *(presv + j) = *(presv + j) + *(pmat + 3*j + i ) * *(pvec + i);
        }
    }
}

void invMat(double *pmat, double *presm)
{
    /* Prototype */
    /* Transpose/Invert the supplied 3x3 matrix */
    for (int i=0;i<3;i++)
    {
        for (int j=0;j<3;j++) *(presm + j + 3*i) = *(pmat + 3*j + i);
    }
}

void matmat(double *pmat0, double *pmat1, double *presm)
{
    /* Function for multiplying matrix with matrix */

    /* Initialize matrix memory addresses with zeros */
    int i; for (i=0;i<9;i++) *(presm + i) = 0;
    /* Is this even necessary? */

    /* Copy the first matrix */
    double mat0[9]; for (i=0;i<9;i++) mat0[i] = *(pmat0+i);

    /* Separate the second matrix into 3 different vectors */
    int itr = 0;
    double mat1c0[3] = {*(pmat1+itr), *(pmat1+itr+3), *(pmat1+itr+6)}; itr++;
    double mat1c1[3] = {*(pmat1+itr), *(pmat1+itr+3), *(pmat1+itr+6)}; itr++;
    double mat1c2[3] = {*(pmat1+itr), *(pmat1+itr+3), *(pmat1+itr+6)};

    /* Initialize the result vectors that will form the resulting matrix */
    double *pfirstCol; double firstCol[3]; pfirstCol = firstCol;
    double *psecondCol; double secondCol[3]; psecondCol = secondCol;
    double *pthirdCol; double thirdCol[3]; pthirdCol = thirdCol;

    /* Calculate the columns of the resulting matrix using regular 
     * matrix multiplication */
    matmul(mat0, mat1c0, pfirstCol);
    matmul(mat0, mat1c1, psecondCol);
    matmul(mat0, mat1c2, pthirdCol);

    /* Is actually using the matmul in this case a good idea? 
     * It kind of feels like it is actually complicating things... */

    /* Allocate the memory necessary for the concatenated array */
    double *pColCat = malloc(9 * sizeof(double));

    /* Concatenate the copied values */
    memcpy(pColCat, pfirstCol, 3*sizeof(double));
    memcpy(pColCat+3, psecondCol, 3*sizeof(double));
    memcpy(pColCat+6, pthirdCol, 3*sizeof(double));

    /* pmat1 + (i-1)*3 + (j-1) */

    /* Invert the matrix */
    for (i=0;i<3;i++)
    {
        for (int j=0;j<3;j++)
        {
            *(presm + j + 3*i) = *(pColCat + 3*j + i);
        }
    }

    //invMat(pColCat, presm);

    /*---------------------------------------- Remove these after confirming */
    /*
    printf("---------------- Debug MSG ----------------\n");
    printf("The tilt compensation feature is under development.");
    printf("[*pColCat]\n");
    for (i=0;i<9;i++) printf(" %f ",*(presm+i));
    printf("\n");
    */
    /* ----------------------------------------------------------------------*/
}

/**
void euler2mat(double phi, double theta, double psi)
{
    * 
        This function converts the euler angles of an objects orientation
        into a rotation matrix. The order of the operation in this case 
        is Z-Y-X extrinsic elementary rotations.

        !! There are ambiguities in different measurement equipment outputs
        thus it needs to be checked with the equipment manual that the 
        order of operations are correct for it. These manuals usually also
        put a formula for converting the euler angles to matrices themselves
    *

    // Calculate the elementary rotation matrices
    double Rx[] = {1,0,0,0,cos(phi),-sin(phi),0,sin(phi),cos(phi)};
    double Ry[] = {cos(theta),0,sin(theta),0,1,0,-sin(theta),0,cos(theta)};
    double Rz[] = {cos(psi),-sin(psi),0,sin(psi),cos(psi),0,0,0,1};

    double hat_z[] = {0.0,0.0,1.0};
    double *ptipv; double tipv[3]; ptipv = tipv;
    matmul(Rx_psi, hat_z, ptipv);
}
*/

void PrintHelp()
{
    printf("\nUSE: xyink [-v] [-a <value>] [-e <value>] \
[-d <value>] \n\n\
OPTIONS:\n\
    -h                 Print this help\n\
    -v                 Verbose\n\
    -a <deg>           Azimuth\n\
    -e <deg>           Elevation\n\
    -d <deg>           XY joint angle\n\
    -t <deg,deg,deg>   Euler angles of the pedestal tilt (under dev)\n\n\
WARNING: Only use positive values.\n\n\
EXAMPLE: xyink -v -a 45 -e 80 -d 90\n\n\
See the manual page for more information: man xyink\n\n");
}

int main(int argc, char *argv[])
{ // XY Pedestal inverse kinematics with orthogonality error compensation
    // ------------------------------------------------------------------------
    // The first command line argument is the executed file itself,
    // therefore the arguments start from argv[1]

    double _ld = M_PI_2;
    double _az = 0;
    double _el = 0;
    double *p_EulerAngles = malloc(3*sizeof(double));/*Tilt angles array*/
    bool tiltFlag = 0;

    //euler2mat(_ld, _ld, _ld);

    /*  The matrix multiplication function test
    double testMat0[] = {1,2,3,4,5,6,7,8,9};
    double testMat1[] = {1,1,1,1,1,1,1,1,1};
    double *presMat; double resMat[9]; presMat = resMat;
    matmat(testMat0, testMat1, presMat);
    */

    int flagCnt = 0; /* Count if any appropriate flags are used */
    for (int indf = 0 ; indf < argc ; indf++)
    {
        char *sarg = argv[indf];
        char sg = '-';
        if (sarg[0] == sg)
        {
            switch (sarg[1])
            {
                case 'v':
                    verbose = true;
                    break;

                case 'a':
                    sscanf(argv[indf + 1], "%lf", &_az);
                    break;

                case 'e':
                    sscanf(argv[indf + 1], "%lf", &_el);
                    break;

                case 'd':
                    default_xy = false;
                    sscanf(argv[indf + 1], "%lf", &_ld);
                    _ld = deg2rad(_ld);
                    break;

                case 't':
                    /* Tilt angle has been given */ 
                    tiltFlag = 1;
                    for (int tc=0;tc<3;tc++)
                        sscanf(argv[indf+tc+1] , "%lf", p_EulerAngles+tc);
                    break;

                case 'h':
                    PrintHelp();
                    return 0;

                default:
                    printf("\n\nERROR: ILLEGAL INPUT\n");
                    PrintHelp();
                    return 1;
            } flagCnt++;
        }
    }

    /*---------------------------------------- Remove these after confirming */
    /*
    printf("---------------- Debug MSG ----------------\n");
    printf("The tilt compensation feature is under development.");
    printf("[*p_EulerAngles]\n");
    for (int i=0;i<3;i++) printf(" %f ",*(p_EulerAngles+i));
    printf("\n");
    */
    /* ----------------------------------------------------------------------*/
    
    if (!flagCnt) 
    {
        /* No appropriate flags were used */
        PrintHelp();
        return 0;
    }

    const double az = deg2rad(-_az); // Put a minus here because NED
    const double el = deg2rad(_el);
    const double ld = _ld;

    /* Construct euler angles array for the radian values */
    double eulerAngles[3]; double *pEulerAngles; pEulerAngles = eulerAngles;

    if (tiltFlag)
    {
        /* Convert the Euler angles to be radians */
        for (int i=0;i<3;i++) eulerAngles[i] = deg2rad(*(p_EulerAngles+i));

        /*------------------------------------ Remove these after confirming */
        /*
        printf("---------------- Debug MSG ----------------\n");
        printf("The tilt compensation feature is under development.");
        printf("[*pEulerAngles]\n");
        for (int i=0;i<3;i++) printf(" %f ",*(pEulerAngles+i));
        printf("\n");
        */
        /* ------------------------------------------------------------------*/
    }

    //////// !!!!!!!! Im here

    // Initialize los vector and los vector pointer
    double los[3]; double *plos; plos = los;

    // First need to calculate the X motor angle
    // Calculate the LOS vector in cartesian coordinates and write it to
    // the address pointed by plos
    sp2ca(az, el, plos);

    // Calculate the nominator for the quadratic equation
    double complex cotld = cos(ld)/sin(ld);
    double complex nomp0 = -(los[0]*cotld);
    double complex nomp1 = 
        csqrt( pow(los[0], 2)*pow(cotld,2)-pow(los[1],2)-pow(los[2],2) );
    // The nominators for the two roots of the quadratic formula
    double complex nom0 = nomp0 + nomp1;
    double complex nom1 = nomp0 - nomp1;
    // Calculate the denominator for the quadratic equation
    double complex den = los[1] - I * los[2];
    // X motor angles, the two roots of the quadratic formula 
    /* Condition the PSI roots */
    double nPSI0 = creal(- I * clog( nom0 / den ) );
    double PSI0 = fmod(nPSI0, PI2);
    double nPSI1 = creal(- I * clog( nom1 / den ) );
    double PSI1 = fmod(nPSI1, PI2);
    /* This is necessary to normalize the PSI roots into -pi < x < pi */
    if (PSI0 > M_PI) PSI0 = PSI0 - PI2;
    if (PSI1 > M_PI) PSI1 = PSI1 - PI2;

    // Get the proper angle of the X motor
    /* Use the PSI root that is in mechanical boundaries */
    double PSI;
    double absPSI0 = fabs(PSI0);
    double absPSI1 = fabs(PSI1);
    if ((absPSI0 < M_PI_2) && (absPSI0 <= absPSI1)) PSI = PSI0;
    else if ((absPSI1 < M_PI_2) && (absPSI1 <= absPSI0)) PSI = PSI1;
    else
    {
        /* PSI degree is out of mechanical bounds */
        PSI = PSI1;
        nosane_roots = true;
    }

    // Now to get the Y motor angle
    //
    // !!!!! CHECK THE OPERATIONAL MISTAKES FIRST THEN GO TO THE METHODICAL
    // Calculate the tip vector rotated by the X motor
    double Rx_psi[] = {1,0,0,0,cos(PSI),-sin(PSI),0,sin(PSI),cos(PSI)};
    double hat_z[] = {0.0,0.0,1.0};
    double *ptipv; double tipv[3]; ptipv = tipv;
    matmul(Rx_psi, hat_z, ptipv);

    // Calculate the Y motor joint axis hat k0 
    double k0v[] = {cos(ld) , sin(ld) , 0};

    // Rotate the k0v to using the X motor angle and create kv
    double *pkv; double kv[3]; pkv = kv;
    matmul(Rx_psi, k0v, pkv);
    // Find the angle between the tip vector and the LOS vector
    // Find the angle sign using the vector product of the tip vector
    // and the LOS vector
    double *p_tipvxlos; double tipvxlos[3]; p_tipvxlos = tipvxlos;
    crossp(tipv, los, p_tipvxlos);
    double len_tipvxlos = veclen(tipvxlos); // !!!!!!!!!!!! VECLEN IS BUGGY
    // Normalize the tipv X los vector to be unitary
    double unit_tipvxlos[3];
    for (int i=0;i<3;i++) unit_tipvxlos[i] = tipvxlos[i]/len_tipvxlos;
    // If the dot product is negative then the los vector is behind
    // the tip vector, therefore the Y motor needs to go CW
    // If the dot product is positive Y motor needs to go CCW
    // If the dot product is zero.. well yeah you are already there
    double unnorm_sign = dotp(unit_tipvxlos, kv);
    double phi_sign;
    if (unnorm_sign < 0) phi_sign = -1;
    else if (unnorm_sign > 0) phi_sign = 1;
    else phi_sign = 0;
    double PHI = phi_sign * acos( dotp(tipv, los));

    if (verbose == true)
    { // Verbose, output all the messages
        printf("\n[ Xyink %s ]\n\n",
                version_text);

        printf("_.INFO\n");
        if (default_xy == true)\
            printf("-| No XY angle entered, defaulting to 90 degrees\n");

        if (symmetric_roots == true)\
            printf("[ WARNING ]: The two PSI roots are symmetric \
using the positive value.\n");

        if (nosane_roots == true)\
            printf("[ WARNING ]: There is no sane X motor angle \
using second root.\n");

        printf("-| The pedestal frame is North-West-Up (NWU)\n");

        /* Without tilt compensation the X rotation axis coincides with north
         * pointing vector and is static. While the Y axis in X zero position
         * is parallel to west pointing vector. */

        if (!tiltFlag)
        {
            printf("-| Not using tilt compensation.\n");
            printf("-| X axis -> North\n");
            printf("-| Y axis at t=0 -> West\n");
        }
        printf("\n");
        /* Inputs */
        printf("_.INPUTS\n");
        printf("-| Azimuth angle: %.2f radians (%.2f degrees)\n",\
                -az, rad2deg(-az));
        printf("-| Elevation angle: %.2f radians (%.2f degrees)\n",\
                el, rad2deg(el));
        printf("-| XY joint angle: %.2f radians (%.2f degrees)\n\n",\
                ld, rad2deg(ld));
        /* Extra Information */
        printf("_.DBG\n");
        printf("-| LOS vector: %f,%f,%f\n", los[0], los[1], los[2]);
        printf("-| PSI0: %f , PSI1: %f\n", PSI0, PSI1);
        printf("-| X transformed tip vector: [ %f,%f,%f ]\n",\
                tipv[0],tipv[1],tipv[2]);
        printf("-| X transformed Y joint axis: [ %f,%f,%f ]\n",\
            kv[0],kv[1],kv[2]);
        printf("-| The length of the tipvxlos : %f\n\n", len_tipvxlos);
        /* Outputs */
        printf("_.OUTPUTS\n");
        printf("-| X angle: %f radians (%f degrees)\n",\
                PSI, rad2deg(PSI));
        printf("-| Y angle: %f radians (%f degrees) \n\n",\
                PHI, rad2deg(PHI));
    }

    else
    { // Not verbose, easy to parse outputs of just XY angles
        printf("%f %f\n",PSI, PHI);
    }
    return 0;
}
