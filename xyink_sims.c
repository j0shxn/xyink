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
}

double complex psi_c0(double alpha, double beta, double lambda, double gamma) 
{
    double cA = cos(alpha); double cB = cos(beta);
    double cL = cos(lambda); double cG = cos(gamma);

    double complex nom = -csqrt( pow(cA,2) * pow(cB,2) - 2*cA*cB*cG*cL + 
            pow(cG,2) + pow(cL,2) - 1) + cA*cB*cL - cG;
    
    double complex den = (sin(alpha)*cB - I*sin(beta)) * sin(lambda);

    double complex psi_res = I * clog(nom/den);
    return psi_res;
}

double complex phi(double alpha, double beta, double lambda, double gamma)
{
    double complex phi_res = casin( (cos(alpha)*cos(beta) - 
            cos(gamma)*cos(lambda))/ (sin(gamma)*sin(lambda)) );
    return phi_res;
}

int main(int argc, char *argv[])
{ 
    double complex psi_res = psi_c0(M_PI/4,M_PI/4,M_PI/2,M_PI/2);
    printf("PSI = %f\n\n", psi_res);

    double complex phi_res = phi(M_PI/4,M_PI/4,M_PI/2,M_PI/2);
    printf("PHI = %f\n\n", phi_res);
    return 0;
}
