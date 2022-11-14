// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21;


contract Contract {
    address private admin;

    address[] public Doctors;
    address[] public Patients;

    struct DoctorConsulation{
        address patient;
        uint startDate;
        uint endDate;
    }

    mapping (address => DoctorConsulation[]) DoctorConsulations;

    struct imageDiagnosis{
        uint date;
        string imageUrl;
        string diagnosis;
    }

    struct doctorDiagnosis{
        uint date;
        string diagnosis;
        string[] symptoms;
        string[] medicaments;
    }

    mapping (address => uint) patientDiagnosisCount;
    mapping (address => imageDiagnosis[]) allImageDiagnosis;
    mapping (address => mapping(address => doctorDiagnosis[] )) allDoctorDiagnosis;

    constructor() {
        admin = msg.sender;
    }

    // get consultaions of doctor

    function getDoctorConsulation(address doctorAdr) public view returns(DoctorConsulation[] memory){
        return DoctorConsulations[doctorAdr];
    }

    // add consultaion for doctor
    
    function addDoctorConsulation(
        address doctorAdr,
        address patient,
        uint startDate,
        uint endDate
    ) public  {
        DoctorConsulations[doctorAdr].push(DoctorConsulation(patient,startDate,endDate));
    }
    
    //get Admin

    function getAdmin() public view returns (address) {
        return admin;
    }

    function isAdmin() public view returns (bool) {
        return admin == msg.sender;
    }

    //Add Doctor

    function addDoctor(address _newdr) public onlyAdmin {
        Doctors.push(_newdr);
    }

    //Add Patient

    function addPatient(address _newdr) public onlyAdmin {
        Patients.push(_newdr);
    }

    // imageDiagnosis

    function addImageDiagnosis (address patientAdr,string memory imageUrl,string memory diagnosis) public {
        allImageDiagnosis[patientAdr].push(imageDiagnosis(block.timestamp,imageUrl,diagnosis));
        patientDiagnosisCount[patientAdr]++;
    }

    function getPatientImageDiagnosis (address patientAdr) public view returns (imageDiagnosis[] memory) {
        return  allImageDiagnosis[patientAdr];
    }



    // doctor diagnosis

    function addDoctorDiagnosis (
        address patientAdr,
        address doctorAdr,
        string memory diagnosis,
        string[] memory symptoms,
        string[] memory medicaments
    ) public {
        allDoctorDiagnosis[patientAdr][doctorAdr].push(doctorDiagnosis(
            block.timestamp,
            diagnosis,
            symptoms,
            medicaments
        ));
        patientDiagnosisCount[patientAdr]++;
    }

    function getPatientDoctorDiagnosis(address patientAdr,address doctorAdr) public view returns (doctorDiagnosis[] memory) {
        doctorDiagnosis[] memory diags = new doctorDiagnosis[](patientDiagnosisCount[patientAdr]);
        uint nb = 0;
        for (uint i=0;i<Doctors.length;i++){
            if (allDoctorDiagnosis[patientAdr][doctorAdr].length > 0){
                for (uint j=0;j<allDoctorDiagnosis[patientAdr][doctorAdr].length;j++){
                    diags[nb] = allDoctorDiagnosis[patientAdr][doctorAdr][j];
                }
            }
        }
        return diags;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin Can Do That");
        _;
    }
}