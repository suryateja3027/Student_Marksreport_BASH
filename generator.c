#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#define MAX_SUBJECTS  4
#define MAX_COURSES  14
#define MAX_DEPTS     4

// Array holding course codes in 4 branches CE, CS, EE, ME
const char *course_code[MAX_DEPTS][MAX_COURSES] = {
	"CE2010", "CE2030", "CE2050", "CE2150", "CE3010", "CE3030", "CE3050", 
    "CE3090", "CE3110", "CE4110", "CE4170", "CE4510", "CE4512", "CE5510", 
	"CS2010", "CS2030", "CS2130", "CS3010", "CS3030", "CS3050", "CS3110", 
    "CS4010", "CS4110", "CS4150", "CS5001", "CS5004", "CS5005", "CS5104",
	"EE2010", "EE2030", "EE2050", "EE2070", "EE2140", "EE2170", "EE3010", 
    "EE3050", "EE3150", "EE3170", "EE4110", "EE4150", "EE4170", "EE4502", 
	"ME2010", "ME2030", "ME3010", "ME3030", "ME3050", "ME3070", "ME3090", 
    "ME3505", "ME3506", "ME3601", "ME4010", "ME4110", "ME4170", "ME4502" 
};

// Function to randomly generate roll number
int get_rollno()
{
    int branch = rand()%4 + 10;
    int year   = rand()%3 + 17;
    int rollno = branch*1e7 + year*1e5 + 1e3 + (rand()%55 + 1);

    return rollno;
}

// Function for fetching course code randomly from course_code array
const char* get_coursecode(int branch)
{

      int course_cd = rand()%MAX_COURSES;
      //printf("%d\n", course_cd);

      return course_code[branch][course_cd];
}

void usage(char *argv[])
{
    printf("Usage: \n");
    printf("\t$ %s  <#output_lines>\n", argv[0]);
    printf("\nwhere: \n\t #output_lines is the number of lines (student records) to generate\n");
    printf("\t (should be non-zero, positive). \n\n");
}

// Main function
int main( int argc, char *argv[] )
{
      int seed = 0, count = 0, num_entries, roll_no, num_subjects, mark;
      const char *course; 
      
      // Checking if there are sufficient command line arguments
      if( (argc < 2) || (atoi(argv[1]) <= 0))
      {
          usage(argv);
          return 1;
      }
 
      srand(time(NULL));
      num_entries = atoi(argv[1]);

      while( count < num_entries )
      {
          roll_no = get_rollno();
          int branch = roll_no/1e7 - 10;

          num_subjects = rand()%MAX_SUBJECTS + 1;
          
          for(int k = 0; k < num_subjects; k++)
          {
               course = get_coursecode(branch);
               mark = rand()%101;
               printf("%d,%s,%d\n", roll_no, course, mark);

               if(++count == num_entries)
                   break;
          }
      }

     return 0;
}
