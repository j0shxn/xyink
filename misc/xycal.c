/*
                              XYINK v0.5-alpha
    XY Inverse Kinematics Program with Orthogonality Error Compensation
    Author: Bugra Coskun
    
    TODO:
        * Write a test case program that checks the C program to the octave 
        inverse formula results from the article.
        * Find the continuity issues in the program and fix them
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

int main(int argc, char *argv[])
{ // XY Pedestal inverse kinematics with orthogonality error compensation
    // ------------------------------------------------------------------------
    // The first command line argument is the executed file itself,
    // therefore the arguments start from argv[1]

    double _ld = M_PI_2;
    double _az = 0;
    double _el = 0;

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
                    break;
                default:
                    printf("\nERROR: ILLEGAL INPUT\n\n");
                    printf("USE: xyink [-v] [-a <value>] [-e <value>] \
[-d <value>] \n\n\
OPTIONS:\n\
    -v      Verbose\n\
    -a      Azimuth\n\
    -e      Elevation\n\
    -d      XY joint angle\n\n\
EXAMPLE: xyink -v -a 45 -e 80 -d 90\n\n");
                    return 0;
            }
        }
    }

    const double az = deg2rad(-_az); // Put a minus here because NED
    const double el = deg2rad(_el);
    const double ld = _ld;

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
    double PSI0 = creal(- I * clog( nom0 / den ) );
    double PSI1 = creal(- I * clog( nom1 / den ) );
    // Get the proper angle of the X motor
    double PSI;
    double absPSI0 = abs(PSI0);
    double absPSI1 = abs(PSI1);
    if ( (absPSI0 < M_PI) && (absPSI0 < absPSI1) ) PSI = PSI0;
    else if ( (absPSI1 < M_PI) && (absPSI0 > absPSI1) ) PSI = PSI1;
    else
    {
        if (absPSI0 == absPSI1)
        {
            if (PSI0 < PSI1) PSI = PSI1;
            else PSI = PSI0;
            symmetric_roots = true;
        }
        else
        {
            PSI = PSI1;
            nosane_roots = true;
        }
        // There is no PSI angle root that is smaller than PI
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
        printf("\n-----------------------[ Xyink v0.6-alpha ]------------------\n");

        if (default_xy == true)\
            printf("No XY angle entered, defaulting to 90 degrees\n");

        if (symmetric_roots == true)\
            printf("[ WARNING ]: The two PSI roots are symmetric \
using the positive value.\n");

        if (nosane_roots == true)\
            printf("[ WARNING ]: There is no sane X motor angle \
using second root.\n");

        printf("The pedestal frame is North-West-Up (NWU)\n");
        printf("Azimuth angle: %.2f radians (%.2f degrees)\n",\
                -az, rad2deg(-az));
        printf("Elevation angle: %.2f radians (%.2f degrees)\n",\
                el, rad2deg(el));
        printf("XY joint angle: %.2f radians (%.2f degrees)\n",\
                ld, rad2deg(ld));
        printf("LOS vector: %f,%f,%f\n", los[0], los[1], los[2]);
        printf("PSI0: %f , PSI1: %f\n", PSI0, PSI1);
        printf("X motor angle: %f radians (%f degrees)\n",\
                PSI, rad2deg(PSI));
        printf("X transformed tip vector: [ %f,%f,%f ]\n",\
                tipv[0],tipv[1],tipv[2]);
        printf("X transformed Y joint axis: [ %f,%f,%f ]\n",\
            kv[0],kv[1],kv[2]);
        printf("The length of the tipvxlos : %f\n", len_tipvxlos);
        printf("Y motor angle: %f radians (%f degrees) \n\n",\
                PHI, rad2deg(PHI));
    }

    else
    { // Not verbose, easy to parse outputs of just XY angles
        printf("%f %f\n",PSI, PHI);
    }
    return 0;
}
