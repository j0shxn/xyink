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
#include <math.h>
#include <complex.h>

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
{ // Calculate the length of a 3D vector
    double len = 0;
    for (int i=0;i<3;i++) len = len + pow(v[i],2); 
    len = sqrt(len);
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

    // Function Tests ---------------------------------------------------------
    /*
    double *pmat; double mat[] = {1,0,0,\
                                  0,1,0,\
                                  0,0,1};
    double *pvec; double vec[] = {1,1,1};
    pmat = mat; pvec = vec;
    double *presv; double resv[3];
    presv = resv;
    matmul(pmat, pvec, presv);
    printf("%f, %f, %f",*(presv), *(presv+1), *(presv+2));
    */
    // ----------------------------------------------------------------------


    printf("[ Xyink v0.5-alpha ]\n");
    double _ld;

    if (argc == 3)
    {
        // If there is no third argument then assume that the first angles
        // are azimuth and elevation and assume that the XY angle is 90 degrees
        printf("No XY angle entered, defaulting to 90 degrees\n");
        _ld = M_PI_2;
    }

    else if (argc == 4)
    {
        // If the number of command line arguments is 3 then assume 
        // azimuth, elevation and XY angle has been entered as degrees
        // Convert the first argument to double
        sscanf(argv[3], "%lf", &_ld);
        _ld = deg2rad(_ld);
    }

    else
    {
        printf("ERROR: ILLEGAL INPUT\n");
        printf("USE\
                xypik <Azimuth Angle> <Elevation Angle> <(opt) XY Angle> \n\
                You don't need to enter the XY angle if it's 90 degrees\n");
        return 0;
    }

    // Get the azimuth and elevation angles in degrees and convert them
    // into radians
    double _az, _el;
    sscanf(argv[1], "%lf", &_az);
    sscanf(argv[2], "%lf", &_el);
    const double az = deg2rad(-_az); // Put a minus here because NED
    const double el = deg2rad(_el);
    const double ld = _ld;
    printf("The pedestal frame is North-West-Up (NWU)\n");
    printf("Azimuth angle: %.2f radians\n",-az);
    printf("Elevation angle: %.2f radians\n",el);
    printf("XY joint angle: %.2f radians.\n",ld);

    // Initialize los vector and los vector pointer
    double los[3]; double *plos; plos = los;

    // First need to calculate the X motor angle
    // Calculate the LOS vector in cartesian coordinates and write it to
    // the address pointed by plos
    sp2ca(az, el, plos);
    printf("LOS vector: %f,%f,%f\n", los[0], los[1], los[2]);
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
    printf("PSI0: %f , PSI1: %f\n", PSI0, PSI1);
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
            printf("WARNING: The two PSI roots are symmetric using the\
positive value.");
        }
        else
        {
            printf("WARNING: There is no sane X motor angle, using second root.");
            PSI = PSI1;
        }
        // There is no PSI angle root that is smaller than PI
    }
    printf("X motor angle: %f radians (%f degrees)\n", PSI, rad2deg(PSI));

    // Now to get the Y motor angle
    //
    // Calculate the tip vector rotated by the X motor
    double Rx_psi[] = {1,0,0,0,cos(PSI),-sin(PSI),0,sin(PSI),cos(PSI)};
    double hat_z[] = {0.0,0.0,1.0};
    double *ptipv; double tipv[3]; ptipv = tipv;
    matmul(Rx_psi, hat_z, ptipv);
    printf("X transformed tip vector: [ %f,%f,%f ]\n", tipv[0],tipv[1],tipv[2]);

    // Calculate the Y motor joint axis hat k0 
    double k0v[] = {cos(ld) , sin(ld) , 0};

    // Rotate the k0v to using the X motor angle and create kv
    double *pkv; double kv[3]; pkv = kv;
    matmul(Rx_psi, k0v, pkv);
    printf("X transformed Y joint axis: [ %f,%f,%f ]\n",\
            kv[0],kv[1],kv[2]);
    // Find the angle between the tip vector and the LOS vector
    // Find the angle sign using the vector product of the tip vector
    // and the LOS vector
    double *p_tipvxlos; double tipvxlos[3]; p_tipvxlos = tipvxlos;
    crossp(tipv, los, p_tipvxlos);
    double len_tipvxlos = veclen(tipvxlos);
    printf("The length of the tipvxlos : %f\n", len_tipvxlos);
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
    printf("Y motor angle: %f radians (%f degrees) \n", PHI, rad2deg(PHI));
    // Peace and happy hacking
    return 0;
}
