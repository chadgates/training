# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Training Dashboard
#
# V1.0 
#
# ©2020 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


export TRAINING_INSTRUCTOR="http://dashboard-default.cp4mcp-demo-002-a376efc1170b9b8ace6422196c51e491-0000.us-south.containers.appdomain.cloud"
export PTE_IMAGE=niklaushirt/pte:training2020-kws107


# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
echo "${GREEN}********************************************************************************${NC}"
echo " ${CYAN}    Setting up your Personal Training Environment (PTE) $DO_NAM ${NC}"
echo " ${CYAN}    --------------------------------------------- $DO_NAM ${NC}"
echo " ${NC}    The following steps will create your web-based Personal Training Environment $DO_NAM ${NC}"
echo " ${NC}    You will have to enter a name that will be used to show your progress in the Instructor Dashboard $DO_NAM ${NC}"
echo " ${NC}    in order to better assist you. $DO_NAM ${NC}"
echo "${GREEN}********************************************************************************${NC}"
echo "  "
echo "  "
echo "  "



# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# GET PARAMETERS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
echo "${CYAN}********************************************************************************${NC}"
echo "${CYAN}--------------------------------------------------------------------------------${NC}"
echo " ${PURPLE}${magnifying} Please enter your name ${NC}"
echo "${CYAN}--------------------------------------------------------------------------------${NC}"

        read -p "Name:" DO_NAM
        if [[ $DO_NAM == "" ]]; then
          echo "${RED}${cross} Aborted: ${ORANGE}Please enter your name so that we can better assist you${NC}"
          exit 2
        else
            DO_NAM=${DO_NAM// /-}
            DO_NAM=${DO_NAM//_/-}
        fi

echo "${CYAN}********************************************************************************${NC}"
echo "${CYAN}--------------------------------------------------------------------------------${NC}"
echo " ${PURPLE}${magnifying} Welcome $DO_NAM ${NC}"
echo "${CYAN}--------------------------------------------------------------------------------${NC}"
echo "${GREEN}********************************************************************************${NC}"
echo "  "
echo " ${CYAN} Preparing your Personal Training Environment${NC}"

        rm -f ~/training/pte/fscollector_student_$DO_NAM.yaml > /dev/null
        cp ~/training/pte/fscollector_student.yaml ~/training/pte/fscollector_student_deploy.yaml

        sed -i "s@TRAINING_NAME@$DO_NAM@" ~/training/pte/fscollector_student_deploy.yaml 
        sed -i "s@TRAINING_INSTRUCTOR@$TRAINING_INSTRUCTOR@" ~/training/pte/fscollector_student_deploy.yaml
        sed -i "s@PTE_IMAGE@$PTE_IMAGE@" ~/training/pte/fscollector_student_deploy.yaml


        kubectl delete -f ~/training/pte/fscollector_student_deploy.yaml > /dev/null
        kubectl apply -f ~/training/pte/fscollector_student_deploy.yaml


        FOUND=0
        echo "${clock} Wait for Personal Training Environment to reach running state."
        while [ ${FOUND} -eq 0 ]; do
          FOUND=$(kubectl get pods | grep student | grep 1/1 | grep -c "")
          echo "${clock} Still waiting for Personal Training Environment to reach running state. This can take some time...."
          sleep 10 
        done 

        minikube service student-ui

echo "${GREEN}********************************************************************************${NC}"
echo "${GREEN}********************************************************************************${NC}"
echo " ${GREEN}${healthy} Personal Training Environment done....${NC}"
echo "${GREEN}********************************************************************************${NC}"
echo "${GREEN}********************************************************************************${NC}"


