# Crime data

crimeDT = fread('./dataset/NYPD_Complaint_Data_Current_YTD.csv')
crimeDT = crimeDT[complete.cases(crimeDT)]
#crimeDT[is.finite(rowSums(crimeDT))]
crimeDT[, c("CMPLNT_FR_TM","CMPLNT_TO_DT","CMPLNT_TO_TM","RPT_DT",
            "CRM_ATPT_CPTD_CD", "JURIS_DESC", "ADDR_PCT_CD",
            "LOC_OF_OCCUR_DESC", "PREM_TYP_DESC", "PARKS_NM",
            "HADEVELOPT","Lat_Lon") := NULL]

