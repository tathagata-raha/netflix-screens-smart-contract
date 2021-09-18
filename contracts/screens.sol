pragma solidity >=0.4.22 <0.9.0;

contract NetflixScreen {

    // event NewZombie(uint zombieId, string name, uint dna);

    struct Item {
        string name;
        string description;
        uint price;
        uint seller;
        uint status;
        uint sold_to;
        string content;
    }

    struct ViewAvlItem {
        uint id;
        string name;
        string description;
        uint price;
        uint seller;
    }
    Item[] public items;

    event ViewItems(ViewAvlItem[] res);
    event BuyItem(Item res);

    mapping (uint => uint[]) public ownerToItemIds;
    mapping (address => uint) UserID;
    uint users = 0;
    function createItem(string memory _name, string memory description, uint price, string memory content) public {
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        items.push(Item(_name, description, price, UserID[msg.sender], 0, 0, content));
    }

    function viewItems() private {
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        ViewAvlItem[] memory res;
        uint itr = 0;
        for (uint i =0; i < items.length; i += 1) {
            Item memory cur = items[i];
            if (cur.status == 0){
                res[itr] = ViewAvlItem(i, cur.name, cur.description, cur.price, cur.seller);
                itr++;
            }
        }
        emit ViewItems(res);
    }

    function buyItem(uint id) public {
        require(items[id].status == 0);
        if(UserID[msg.sender] == 0){
            UserID[msg.sender] = users + 1;
            users++;
        } 
        items[id].status = 1;
        items[id].sold_to = UserID[msg.sender];
        emit BuyItem(items[id]);
    }

}
