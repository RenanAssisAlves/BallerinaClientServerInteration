import ballerina/http;
import ballerina/io;

class Car {
    int id;
    string name;
    int value;
    int yearOfManufacture;
    boolean sold;
    
    function init(int id, string name, int value, int yearOfManufacture, boolean sold)
    {
        self.id = id;
        self.name = name;
        self.value = value;
        self.yearOfManufacture = yearOfManufacture;
        self.sold = sold;
    }


    function returnJson() returns json
    {
        json tempJson = {
            "id" : self.id,
            "name" : self.name,
            "value" : self.value,
            "yearOfManufacture" : self.yearOfManufacture,
            "sold" : self.sold
        };
        return tempJson;
    }
}

public function main() returns error? {

    final http:Client clientEndpoint = 
                            check new ("localhost:8080");
    
    json resp = check clientEndpoint->get("/car/list");

    io:println("Get car list:\n", resp);
    
    json insertNewCar = [
                          {
                            "id": "5",
                            "name": "Volkswagen Caravan",
                            "value": 19000,
                            "yearOfManufacture": 2000,
                            "sold": true
                          }
                        ];
    json response = check clientEndpoint->post("/car/add", insertNewCar);
    io:println();
    io:println("Insert new car: ", response);

    
}
