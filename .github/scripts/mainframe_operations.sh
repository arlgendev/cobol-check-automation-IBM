#!/bin/bash

# mainframe_operations.sh

# Set up environment
export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64
export PATH=$PATH:/usr/lpp/zowe/cli/node/bin

# Check Java availability
java -version

# Set ZOWE_USERNAME
ZOWE_USERNAME="Z74881"  # Replace with your actual username

# Change to the cobolcheck directory
cd cobolcheck
echo "Changed to $(pwd)"
ls -al

# Make cobolcheck executable
chmod +x cobolcheck
echo "Made cobolcheck executable"

# Make script in scripts directory executable
cd scripts
chmod +x linux_gnucobol_run_tests
echo "Made linux_gnucobol_run_tests executable"
cd ..

# Function to run cobolcheck and copy files
run_cobolcheck() {
  program=$1
  echo "Running cobolcheck for $program"

  if [ -f "cobolcheck" ]; then
    echo "run_cobolcheck(): cobolcheck -> EXISTE"
  else
    echo "run_cobolcheck(): cobolcheck -> NAO existe"
  fi

  # Run cobolcheck, but don't exit if it fails
  ./cobolcheck -p $program
  echo "Cobolcheck execution completed for $program (exceptions may have occurred)"

  # Note: The "CC##99.CBL" file name below is NOT a placeholder
  # Keep it as is in the code
  
  # Check if CC##99.CBL was created, regardless of cobolcheck exit status
  if [ -f "testruns/CC##99.CBL" ]; then
    # Copy to the MVS dataset
    if cp "testruns/CC##99.CBL" "//'${ZOWE_USERNAME}.CBL($program)'"; then
      echo "Copied CC##99.CBL to $ZOWE_USERNAME.CBL($program)"
    else
      echo "Failed to copy CC##99.CBL to $ZOWE_USERNAME.CBL($program)"
    fi
  else
    echo "CC##99.CBL not found for $program"
  fi

  # Copy the JCL file if it exists
  if [ -f "${program}.JCL" ]; then
    if cp ${program}.JCL "//'$ZOWE_USERNAME.JCL($program)'"; then
      echo "Copied ${program}.JCL to $ZOWE_USERNAME.JCL($program)"
      # Submit job to run testing version of the program
      submit ${program}.JCL
      echo "Submitted job ${program}.JCL"
    else
      echo "Failed to copy ${program}.JCL to $ZOWE_USERNAME.JCL($program)"
    fi
  else
    echo "${program}.JCL not found"
  fi
}

# Run for each program
for program in NUMBERS EMPPAY DEPTPAY; do
  run_cobolcheck $program
done

echo "Mainframe operations completed"
