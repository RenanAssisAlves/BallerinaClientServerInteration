//import ballerina/io;
import ballerina/http;

listener http:Listener httpListener = new (8080);

public type Car record {
    readonly int id;
    string name;
    int value;
    int yearOfManufacture;
    boolean sold;
};

public final table<Car> key(id) carTable = table
[
 {id: 0, name: "Ferrari", value: 1900000, yearOfManufacture: 2005, sold: false},
 {id: 1, name: "Buggati", value: 230000, yearOfManufacture: 2007, sold: false},
 {id: 2, name: "Toyota 4x4", value: 200000, yearOfManufacture: 2019, sold: true}
];
 
service / on httpListener{
    resource function get cars() returns Car[] {
        return carTable.toArray();
    }
}

// public function main() {
//     io:println("Program started!");
// }
