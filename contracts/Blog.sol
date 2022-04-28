//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {

    // state variables to keep track of what the name of the blog is and the owner of the blog
    string public name;
    address public owner;

    // uses the counter from openzeppelin
    // counters can only be incremented or decremented by one
    // e.g: _postIds.current(); -> returns the current counter
    //      _postIds.increment(); -> increments _postIds up by one
    //      _postIds.decrement(); -> decrements _postIds down by one
    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    // data structure for a post
    struct Post {
        uint id; // uint is unsigned integer (can not have negative values)
        string title;
        string content;
        bool published;
    }

    // each Post has an associated uint key
    // e.g idToPost[uint] will return the associated post
    mapping(uint => Post) private idToPost;
    // each Post has an associated string key
    // e.g hashToPost[string] will return an associated post
    mapping(string => Post) private hashToPost;

    // event for function createPost
    event PostCreated(uint id, string title, string hash);
    // event for function updatePost
    event PostUpdated(uint id, string title, string hash, bool published);

    // a contract only has one constructor
    // it is executed only one time when the contract is created
    // updates name to _name and owner to the owner of the contract
    constructor(string memory _name){
        console.log("Deploying Blog with name:", _name);
        name = _name;
        owner = msg.sender;
    }

    // updateName updates name to _name
    function updateName(string memory _name) 
    public {
        name = _name;
    }

    // transferOwnership updates owner to newOwner
    // requires: owner of the blog must be the owner of the contract
    function transferOwnership(address newOwner) 
    public onlyOwner { // onlyOwner is a function modifier that require the owner of the blog to be the owner of the contract
        owner = newOwner;
    }


    // onlyOwner requires that the owner of the blog to be the owner of the contract
    modifier onlyOwner(){ // modifiers modify the behaviour of a function and often used to add prerequisites
        require(msg.sender == owner);
        _; // _; means rest of the code is inserted here
    }

    // fetchPost returns a post with the associated hash
    function fetchPost(string memory hash) 
    public view returns(Post memory){ // view functions ensures state variables cannot be modified 
        return hashToPost[hash];
    }

    // createPost initializes a new post with title and hash
    // effects: emits PostCreated
    function createPost(string memory title, string memory hash)
    public onlyOwner {
        _postIds.increment(); // increment the post id
        uint postId = _postIds.current(); // set a new var to the current post id (that was incremented)
        Post storage post = idToPost[postId];
        // new post is created, we now assign the values in the post struct
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post;
        emit PostCreated(postId, title, hash); // stores the arguments passed in transaction logs
        // basically logs that a post has been created
    }

    // updates Post with postId to have a new title, hash, and published status
    // effects: emits PostUpdated
    function updatePost(uint postId, string memory title, string memory hash, bool published)
    public onlyOwner {
        Post storage post = idToPost[postId]; // local variable post is created
        // all vals are updated
        post.title = title;
        post.published = published;
        post.content = hash;

        // updates post in both  mappings
        idToPost[postId] = post; 
        hashToPost[hash] = post;
        // stores in transaction logs
        emit PostUpdated(post.id, title, hash, published);
    }

    // returns an array of all posts
    function fetchPosts() public view returns (Post[] memory) {
        uint itemCount = _postIds.current();
        // since there's not really dynamic arrays in solidity, we must get a new int
        // in order to iterate the posts through a for loop

        Post[] memory posts = new Post[](itemCount); // initialize an empty array of size itemCount

        for (uint i = 0; i < itemCount; i++){
            uint currentId = i + 1; // new int called currentId
            Post storage currentItem = idToPost[currentId]; // get a new post, currentItem, from the current id
            posts[i] = currentItem; // assign currentItem to that new place in the array 
        }

        // return the array
        return posts;
    }

}
