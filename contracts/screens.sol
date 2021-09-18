pragma solidity >=0.4.22 <0.9.0;

contract NetflixScreen {

    // event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Item {
        string name;
        string description;
        uint price;
        uint seller;
        uint status;
        string sold_to;
    }

    struct ViewAvlItem {
        uint id;
        string name;
        string description;
        uint price;
        uint seller;
    }
    Item[] public items;

    mapping (uint => uint[]) public ownerToItemIds;
    mapping (address => uint) UserID;
    uint users = 0;

    function createItem(string memory _name, string memory description, uint price) public {
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        uint id = items.push(Item(_name, description, price, UserID[msg.sender], 0, "None")) - 1;
        ownerToItemIds[UserID[msg.sender]].push(id);
    }

    function viewItems() private view returns (uint) {
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        ViewAvlItem[] memory res;
        for (uint i =0; i < items.length; i += 1) {
            Item memory cur = items[i];
            if (cur.status == 0)
                res.push(ViewAvlItem(i, cur.name, cur.description, cur.price, cur.seller));
        }
        return res;
    }

    function buyItem(uint id) public {
        require(items[id].status == 0);
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        items[id].status = 1;
        items[id].sold_to = UserID[msg.sender];
        return items[id];
    }

}
