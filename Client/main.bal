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
            "name" : self.name,
            "value" : self.value,
            "yearOfManufacture" : self.yearOfManufacture,
            "sold" : self.sold
        };
        return tempJson;
    }

}

public function main() {
    //
}
