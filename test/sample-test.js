const { expect } = require("chai");
const { ethers } = require("hardhat");

// CONTRACT DOCUMENTATION
// ============================================================================================================
// string name keeps track of what the name of the blog is
// address owner keeps track of what the owner of the owner is

// updateName(string memory _name) updates name to _name

// transferOwnership(address newOwner)  updates owner to newOwner
// requires: onlyOwner

// fetchPost(string memory hash) returns a post with the associated hash

// createPost(string memory title, string memory hash) initializes a new post with title and hash
// requires: onlyOwner
// effects: emits PostCreated

// updatePost(uint postId, string memory title, string memory hash, bool published)
// updates Post with postId to have a new title, hash, and published status
// requires: onlyOwner
// effects: emits PostUpdated

// fetchPosts() returns Post[] of all posts
// ============================================================================================================

// in hardhat to test functions the format is
// describe("test_name", function(){
// it("test1", [async] function){ 
//        [testing goes here]
//    })
// it("test2", [async] function){
//        [testing goes here]
//    })
// }
describe("Blog", function () { 

  // tests if a new post is created
  it("Should create a post", async function () {
    // note there is Blog which is a promise that resolve to a ContractFactory
    // there is also blog which is a promise that resolve to a Contract
    const Blog = await ethers.getContractFactory("Blog") // Blog is a ContractFactory which can be deployed
    const blog = await Blog.deploy("My blog") 
    await blog.deployed() // wait for blog to be deployed
    await blog.createPost("My first post", "12345") // calls createPost with title of "My first post" and hash "12345"

    const posts = await blog.fetchPosts() // posts is a promise which resolves to an array of Post

    // In hardhat to check for values the format is
    // expect(value).to.equal(expected_value)
    expect(posts[0].title).to.equal("My first post")
  })

  // tests if the name can be updated
  it("Should add update the name", async function () {
    // Blog is a promise which resolves to a ContractFactory
    // Blog is then deployed
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy("My blog")
    await blog.deployed()

    // first check that the name is My Blog
    expect(await blog.name()).to.equal("My blog")

    // update the name
    await blog.updateName('My new blog')
    // check if the name updated
    expect(await blog.name()).to.equal("My new blog")
  })

  // tests if you can update the contents(hash) of a post
  it("Should edit a post", async function () {
    // Blog is a promise which resolves to a ContractFactory
    // Blog is then deployed
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy("My blog")
    await blog.deployed()

    // create a new post
    await blog.createPost("My Second post", "12345")

    // update the post
    await blog.updatePost(1, "My updated post", "23456", true)

    // get an array of posts
    posts = await blog.fetchPosts()

    // checks it
    expect(posts[0].title).to.equal("My updated post")
  })

  it("checks if fetchPost works", async function(){
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy("My blog")
    await blog.deployed

    await blog.createPost("TESTING!", "12345")
    post = await blog.fetchPost("12345")

    expect(post.title).to.equal("TESTING!")
  })
});
