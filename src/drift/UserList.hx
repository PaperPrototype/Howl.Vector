package drift;

class UserList {
    public var users:Array<String>;

    public function new() {
        users = [];
    }

    public function addUser(name:String):Void {
        users.push(name);
    }

    public function getUserCount():Int {
        return users.length;
    }
}