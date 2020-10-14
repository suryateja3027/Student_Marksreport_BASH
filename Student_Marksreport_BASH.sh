#!/bin/bash
#specifying both long and short options, some with accepting arguments(:) and other without
SHORT=sg:c:b:
LONG=setup,generate:,course:,branch:
OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
while  true ; do
        case "$1" in
                -s | --setup )    make 
		               	  shift
			      	  ;;
                -g | --generate ) no_stu="$2"
				  rm -r main &> /dev/null
				  #checking no of arguments, whether given custom csv file or not
				  if [ "$#" -ne 3 ]
				  then
					  master='master'
					  mkdir main &> /dev/null
       					  ./generator "$no_stu" > ./main/"$master".csv
					  
					  shift 2
				  else
					  master="$3"
					  mkdir main &> /dev/null
					  ./generator "$no_stu" > ./main/"$master".csv  
					  shift 3
				  fi 
				  ;;
                -c | --course )   course_name="$2"
				 
                                  mkdir courses &> /dev/null
#making 1st and 2nd columns as a primary key and picking up the maximum marks from 3rd column with awk for same student and same course
				  awk 'BEGIN{FS = ",";OFS = ",";} $3 >= a[$1,$2]{a[$1,$2] = $3} END{for (i in a) print i, a[i]}' ./main/*.csv | awk '{print substr($0,1,9) "," substr($0,11)}' > test1.csv
				  if [[ $course_name = "all" ]]
				  then
					  #getting all courses in sorted and unique way
					  cut -d "," -f2 test1.csv | sort -d | uniq > test2.csv
					  for i in $(cat test2.csv)
					  do
						 #searching required course
						grep -w "$i" test1.csv | cut -d"," -f1,3 > courses/"$i".csv
					  done
				  else
					  grep -w $course_name test1.csv | cut -d"," -f1,3 > courses/$course_name.csv
				  fi
				  rm test1.csv test2.csv &> /dev/null
				  shift 2
				  ;;
		-b | --branch ) branch_name="$2"
				  
				  if [[ $branch_name == "all" ]]
				  then
					  for b in CE CS EE ME
					  do
						  awk 'BEGIN{FS = ",";OFS = ",";} $3 >= a[$1,$2]{a[$1,$2] = $3} END{for (i in a) print i, a[i]}' ./main/*.csv | awk '{print substr($0,1,9) "," substr($0,11)}' > test1.csv
						  rm $b.csv &> /dev/null
                                		  grep $b test1.csv | cut -d"," -f1 | sort | uniq > rollno.csv
                                		  grep $b test1.csv | cut -d"," -f2 | sort | uniq > subject.csv
		                                  echo -e -n "RollNo\t" >> $b.csv
						  #printing header row
                  		                  for k in $(cat subject.csv)
                                		  do
	                                          echo -e -n "$k\t" >> $b.csv
          		                          done
                            		          echo "" >> $b.csv

		                                for i in $(cat rollno.csv)
                		                do
							#adding rollnos in header column
                                		        echo -e -n "$i\t" >> $b.csv
                                                	for j in $(cat subject.csv)
                                                        do
								#getting marks for a student of corresponding course
                                                                marks=$(grep "$j" test1.csv | grep "$i" | cut -d"," -f 3)
                                                                if [[ $marks -ge 0 ]]
                                                                then echo -e -n "$marks\t" >> $b.csv
                                                                else
                                                                echo -e -n " \t" >> $b.csv
                                                                fi
                                                        done
                                        	echo "" >> $b.csv
		                                done
                		                rm test1.csv rollno.csv subject.csv &> /dev/null
					done
				else
					awk 'BEGIN{FS = ",";OFS = ",";} $3 >= a[$1,$2]{a[$1,$2] = $3} END{for (i in a) print i, a[i]}' ./main/*.csv | awk '{print substr($0,1,9) "," substr($0,11)}' > test1.csv
				rm $branch_name.csv &> /dev/null
				grep $branch_name test1.csv | cut -d"," -f1 | sort | uniq > rollno.csv
				grep $branch_name test1.csv | cut -d"," -f2 | sort | uniq > subject.csv
				echo -e -n "RollNo\t" >> $branch_name.csv
				for k in $(cat subject.csv)
				do
        				echo -e -n "$k\t" >> $branch_name.csv
				done
				echo "" >> $branch_name.csv

				for i in $(cat rollno.csv)
				do
        				echo -e -n "$i\t" >> $branch_name.csv
        					for j in $(cat subject.csv)
        						do
                        					marks=$(grep "$j" test1.csv | grep "$i" | cut -d"," -f 3)
                        					if [[ $marks -ge 0 ]]
                        					then echo -e -n "$marks\t" >> $branch_name.csv
                        					else
                                				echo -e -n " \t" >> $branch_name.csv
                        					fi
                					done
                			echo "" >> $branch_name.csv
				done
				rm test1.csv rollno.csv subject.csv &> /dev/null
				  fi
				shift 2
				;;

	        *) 		  exit 1
				  ;;
        esac
done
#---------------:															
#	--	:
#	---	:-------------------------------------------------------------------------------------------------------------------------------
#	----	:$./152002014.sh -shortoption [argument] or --longoption [argument]-------------------------------------------------------------
#	-----	:Time taken while testing for 100 Million records->-g(24s),-c all(48s),-b all(212s)---------------------------------------------
#--------------	:Ensure Makefile and generator.c files present in same working directory--------------------------------------------------------
#---------------:options------------------------------------------------------------------------------------------------------------------------
#--------------	:-s or --setup--------------------------------------------------------> Creates executable generator file-----------------------
#	-----	:-g <number> or --generator <number>----------------------------------> Generates the default master.csv file-------------------
#	----	:-g <number> <custom_csv_file> or --generator <no> <custom_csv_file>--> Same as above but with custom .csv file-----------------
#	---	:-c <course_name/all> or --course <course_name/all--------------------> Generate the course file[s] for the course mentioned----
#	--	:-b <branch_name/all> or --branch <branch_name/all--------------------> Generate the branch file[s] for the branch mentioned----
#-------------------------------------------By Parisa Surya Teja | MTech SoCD | 152002014@smail.iitpkd.ac.in -----------------------------------
