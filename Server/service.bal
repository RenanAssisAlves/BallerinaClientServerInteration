//import ballerina/io;
import ballerina/http;

listener http:Listener httpListener = new (8080);

public type Car record {
    readonly string id;
    string name;
    int value;
    int yearOfManufacture;
    boolean sold;
};

public final table<Car> key(id) carTable = table
[
 {id: "0", name: "Ferrari", value: 1900000, yearOfManufacture: 2005, sold: false},
 {id: "1", name: "Buggati", value: 230000, yearOfManufacture: 2007, sold: false},
 {id: "2", name: "Toyota 4x4", value: 200000, yearOfManufacture: 2019, sold: true}
];
 
service / on httpListener{
    resource function get car/list() returns Car[] {
        return carTable.toArray();
    }

    resource function get car/list/sold() returns Car[] {
        Car[] carList = carTable.toArray();
        Car[] carSold = [];
        foreach Car car in carList {
            if car.sold
            {
                carSold.push(car);
            }
        }
        return carSold;
    }

    resource function get car/list/unsold() returns Car[] {
        Car[] carList = carTable.toArray();
        Car[] carSold = [];
        foreach Car car in carList {
            if !car.sold
            {
                carSold.push(car);
            }
        }
        return carSold;
    }

    resource function post car/add(@http:Payload Car[] carEntries) returns ConflictingIdCodesError|CreatedCarEntries
    {
        string[] conflictingIds = from Car carEntry in carEntries
        where carTable.hasKey(carEntry.id)
        select carEntry.id;

        if conflictingIds.length() > 0 {
            return <ConflictingIdCodesError>{
                body: {
                    errmsg: string:'join(" ", "Conflicting Car ID :", ...conflictingIds)
                }
            };
        }
        else {
            carEntries.forEach(carEntry => carTable.add(carEntry));
            return <CreatedCarEntries> {body: carEntries};
        }
    }

    resource function get car/[string id]() returns Car|http:NotFound {
        Car? car = carTable[id];
        if car is () {
            return <http:NotFound>{};
        } else {
            return car;
        }
    }
}


public type CreatedCarEntries record {|
    *http:Created;
    Car[] body;
|};

public type ConflictingIdCodesError record {|
    *http:Conflict;
    ErrorMsg body;
|};

public type InvalidIdError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};