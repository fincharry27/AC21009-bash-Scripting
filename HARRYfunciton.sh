username=$(whoami)

#lISTS ALL AVALIABLE FILES
echo "---Avaliable Files---"
ls
echo "Enter the file name of the file you wish to edit: "
read fileName

#This was an attempt at the reverting file versions extension but due to the weird formatting of our archived files it doesn't work

# echo "Do you wish to revert this file to a previous version? Only works for existing files. (y for yes, anything else for no): "
# read userInput

# if [ $userInput = "y" ]; then
#     cd olderVersion && cd "${fileName}-archive"
#     pwd && echo "Showing archived files" && ls
#     echo "Enter the name of the file you wish to revert to: "
#     read revertFileName
#     if [ -f $revertFileName ]; then
#         mv $revertFileName ../../$fileName
#         echo "File reverted."
#     else
#         echo "This file does not exist"
#     fi
# else

    #IF THE FILE EXISTS THEN COPY IT TO A TEMP FOLDER, AND COPY IT'S CURRENT STATE TO THE FILE'S ARCHIVE DIRECTORY AND ADD ITS VERSION NUMBER, IF NOT THEN FAIL
    #IT'S SUPPOSED TO ADD THE NUMBER OF FILES THAT HAVE THE SAME NAME IN THEIR NAME AS A NUMBER TO THE END OF THE FILE NAME SO YOU'D HAVE TEST.TXT-VERSION-1, TEST.TXT-VERSION-2,
    #BUT I CAN'T GET THE NUMBER THAT THE COMMAND NEXT TO numberOfFiles TO STORE AS A VARIABLE AND IT'S REALLY FRUSTRATING - left this comment in beacuse its funny, it works now
    #and it was all because of a space between the variable name and the equals sign. You really do love to see it. i left this comment in to laugh at myself for spending nearly
    #an hour angry because of a space

    if [ -f $fileName ]; then

        mkdir temp && cp $fileName temp

        if [ -d olderVersion ]; then
            cd olderVersion
            if [ -d "${fileName}-archive" ]; then
                cd "${fileName}-archive"
                numberOfFilesCommand=$(ls -dq ${fileName}* | wc -l)
                numberOfFiles=$numberOfFilesCommand
                cd .. && cd ..
                cp $fileName olderVersion/"${fileName}-Version-${numberOfFiles}.txt"
                cd olderVersion
                mv "${fileName}-Version-${numberOfFiles}.txt" "${fileName}-archive"
                cd ..
            else
                mkdir "${fileName}-archive"
                cd "${fileName}-archive"
                numberOfFilesCommand=$(ls -dq ${fileName}* | wc -l)
                numberOfFiles=$numberOfFilesCommand
                cd .. && cd ..
                cp $fileName olderVersion/"${fileName}-Version-${numberOfFiles}.txt"
                cd olderVersion
                mv "${fileName}-Version-${numberOfFiles}.txt" "${fileName}-archive"
                cd ..
             fi 
        else
            mkdir olderVersion
            cd olderVersion
            mkdir "${fileName}-archive"
            cd "${fileName}-archive"
            numberOfFilesCommand=$(ls -dq ${fileName}* | wc -l)
            numberOfFiles=$numberOfFilesCommand
            cd .. && cd ..
            cp $fileName olderVersion/"${fileName}-Version-${numberOfFiles}.txt"
            cd olderVersion
            mv "${fileName}-Version-${numberOfFiles}.txt" "${fileName}-archive"
            cd ..
        fi

        #MOVE THE FILE INTO A NEW FOLDER TO SIGNIFY THAT IT IS IN USE
        mkdir filesInUse && mv $fileName filesInUse && cd filesInUse && nano $fileName
        while [ -n "`pgrep nano`"  ]; do :; done
        #MOVE THE FILE OUT OF IN USE FOLDER AND DELETE THAT DIRECTORY
        mv $fileName .. && cd .. && rmdir filesInUse

        #IF THE BACKUPS FOLDER EXISTS THEN COPY THE NEW VERSION OF THE FILE INTO IT, IF NOT CREATE THE DIRECTORY AND DO THE SAME
        if [ -d backups ]; then
            cp $fileName backups/"${fileName}-backup.txt"
        else
            mkdir backups && cp $fileName backups/"${fileName}-backup.txt"
        fi

        #IF THE LOGS FOLDER EXISTS THEN CREATE A LOG BASED ON THE DIFFERENCES OF THE FILES, IF NOT CREATE THE DIRECTORY AND DO THE SAME
        if [ -d log ]; then
            echo "---EDIT---" >> log/"${fileName}-${username}-edit-log.txt"
            diff -c $fileName temp/$fileName >> log/"${fileName}-${username}-edit-log.txt"
            echo "" >> log/"${fileName}-${username}-edit-log.txt"
        else
            mkdir log
            echo "---EDIT---" >> log/"${fileName}-${username}-edit-log.txt"
            diff -c $fileName temp/$fileName >> log/"${fileName}-${username}-edit-log.txt"
            echo "" >> log/"${fileName}-${username}-edit-log.txt"
        fi

        #REMOVE THE OLD VERSION OF THE FILE FROM THE TEMP FOLDER AND DELETE THIS FOLDER
        rm temp/$fileName && rmdir temp

        #ASK USER TO ADD A COMMENT TO THE LOG ENTRY
        echo "Please add a comment for your entry (leave blank if not): "
        read comment
        echo "---${username}'s edit comment---">>log/"${fileName}-${username}-edit-log.txt" && echo $comment >> log/"${fileName}-${username}-edit-log.txt"

    else
        echo "File does not exist"
    fi
#fi