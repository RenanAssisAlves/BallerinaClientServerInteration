import ballerina/http;
import ballerina/io;
import ballerina/lang.'int as langint;

class Car {
    string id;
    string name;
    int value;
    int yearOfManufacture;
    boolean sold;
    
    function init(string id, string name, int value, int yearOfManufacture, boolean sold)
    {
        self.id = id;
        self.name = name;
        self.value = value;
        self.yearOfManufacture = yearOfManufacture;
        self.sold = sold;
    }
    
    function getCarId() returns string
    {
        return self.id;
    }

    function getCarName() returns string
    {
        return self.name;
    }

    function gerCarValue() returns int
    {
        return self.value;
    }

    function getCarYearOfManufacture() returns int
    {
        return self.yearOfManufacture;
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

    function IsSold() returns boolean
    {
        if (self.sold)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

public function main() returns error? {

    final http:Client clientEndpoint = check new ("localhost:8080");
    
    json responseList = check clientEndpoint->get("/car/list");

    io:println("Get car list before insertion:\n", responseList, "\n\n");
    
    json insertNewCar = [
                          {
                            "id": "5",
                            "name": "Volkswagen Caravan",
                            "value": 19000,
                            "yearOfManufacture": 2000,
                            "sold": true
                          },
                          {
                            "id": "6",
                            "name": "Motor cross",
                            "value": 2000,
                            "yearOfManufacture": 2010,
                            "sold": false
                          }
                        ];
                        
    json responseAdd = check clientEndpoint->post("/car/add", insertNewCar);
    io:println("Insert new car: ", responseAdd, "\n\n");


    responseList = check clientEndpoint->get("/car/list");

    io:println("Get car list after insertion:\n\n", responseList, "\n\n");

    io:println("Show if cars are available for purchase or its already sold:\n");
    json[] jsonArray = <json[]>responseList;
    foreach json car in jsonArray {
        map<json> mapcar = <map<json>>car;
        string id = mapcar["id"].toString();
        string name = mapcar["name"].toString();
        int value = check langint:fromString(mapcar["value"].toString());
        int yearOfManufacture = check langint:fromString(mapcar["yearOfManufacture"].toString());
        boolean sold = check boolean:fromString(mapcar["sold"].toString());
        

        Car carObj = new (id, name, value, yearOfManufacture, sold);
        
        if (carObj.IsSold())
        {
            io:println("Car ", carObj.getCarName(), " is sold");
        }
        else
        {
            io:println("Car ", carObj.getCarName(), " is available for purchase");
        }
    }
}
