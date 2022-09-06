const express=require('express');
const router=express.Router();
const db=require('../../core/db');
const bcrypt=require('bcrypt');
const jwt=require('jsonwebtoken');
var multer=require('multer');
var path=require('path');


const pool= db.pool;

//----------------------------------repeatedly used  functions------------------------------------------//

//function for deleting an entry
function deleteEntry(con,table,userEmail,postId){
    var sql=`DELETE FROM ${table} WHERE user_email='${userEmail}' AND post_id='${postId}' `;

    con.query(sql,(err,result)=>{
        if(err)
            console.log(err);
    });
}
    
//function for fetching responses:comments,slaps,claps
function fetchResponse(con,response,postId){
    var sql=`SELECT * FROM ${response} WHERE post_id='${postId}'`;

    return new Promise((resolve,reject)=>{
        con.query(sql,(err,results)=>{
            if(err){
                return reject(err);
            }
            resolve(results);
            
        });
    });
}

//-----------------------------------------------------------------------------------------------------//

router.post('/postText',(req,res,next)=>{
    var userName=req.body.userName;
    var userEmail=req.body.userEmail;
    var post=req.body.post;
    var post_type=req.body.post_type;
    
    
    //handle text posts
    if(post_type=='text'&&userName!=null && userEmail!=null && post!=null){
        pool.getConnection((err,con)=>{
            if(!err){
                console.log("post connection established successfully");
            
        
                var sql=`INSERT INTO posts(id,date,user_name,user_email,\
                    post_type,post) VALUES(null,now(),'${userName}','${userEmail}','${post_type}',"${post}")`;

                console.log(sql);

                con.query(sql,function(err,result){
                    if(err){
                        res.status(500).json({
                            error:{
                                message:err
                            }
                        });
                        console.log(err);
                    }
                    else{
                        console.log('posts updated successfully');

                        return res.status(200).json({
                            message:'success'
                        });
                    }
                });
            
                con.release();
            }
            else{
                console.log(err);
            }
        });
    }
});

//locate storage for storing inages and videos
var storage=multer.diskStorage({
    destination: function (request, file, cb){//cb is callback 
        cb(null, filePath)
    },
    filename: function(request,file,cb){
                               
        cb(null,file.originalname);
    }
});

const fileFilter=(request,file,cb)=>{
    if(file.mimetype=='image/jpeg'|| file.mimetype =='image/jpg' ||file.mimetype=='image/png'||
    file.mimetype=='video/mp4'){
        cb(null,true);
    }else{
        cb(null,false);
    }
}

var upload=multer({
    storage:storage
});

var filePath=path.join(__dirname+'../../../../ImagesAndVideos/');

router.post('/postImgVid',upload.single('image'),(req,res,next)=>{
    console.log("thiss",req.body);    
    
    var userName=req.body.userName;
    var userEmail=req.body.userName;
    var caption=req.body.caption;
    var fileName=req.body.fileName;

    //console.log("thiss",req.fields.caption);    

    console.log('rre');
    // upload image and video
    if(userName!=null && userEmail!=null ){
        
        pool.getConnection((err,con)=>{
            if(!err){
                console.log("post connection established successfully");
            
                
                
                
                var sql=`INSERT INTO posts(id,date,user_name,user_email,\
                    post_type,post,caption) VALUES(null,now(),'${userName}','${userEmail}','imgVid',"${filePath+fileName}","${caption}")`;

                console.log(sql);

                con.query(sql,function(err,result){
                    if(err){
                        res.status(500).json({
                            error:{
                                message:err
                            }
                        });
                        console.log(err);
                    }
                    else{
                        console.log('posts updated successfully');

                        return res.status(200).json({
                            message:'success'
                        });
                    }
                });
            
                con.release();
            }
            else{
                console.log(err);
            }
        });
    }

});

//------------------------------------post directly to admin-----------------------------------------------------------------//

router.post('/postDirect',(req,res,next)=>{
    
    var post=req.body.post;

    if( post!=null){
        pool.getConnection((err,con)=>{
            if(!err){
                console.log("post connection established successfully");
            
        
                var sql=`INSERT INTO directPosts(id,datetime,\
                    post) VALUES(null,now(),"${post}")`;

                console.log(sql);

                con.query(sql,function(err,result){
                    if(err){
                        res.status(500).json({
                            error:{
                                message:err
                            }
                        });
                        console.log(err);
                    }
                    else{
                        console.log('posts updated successfully');

                        return res.status(200).json({
                            message:'success'
                        });
                    }
                });
            
                con.release();
            }
            else{
                console.log(err);
            }
        });
    }

});




//------------------------HANDLE FETCH OF POSTS FROM DATABASE-----------------------------//

function promiseQuery(query,con){
    return new Promise((resolve,reject)=>{
        con.query(query,(err,results)=>{
            if(err){
                return reject(err);
            }
            resolve(results);
            
        });
    });
}

router.get('/getPosts',(req,res,next)=>{
    pool.getConnection(async(err,con)=>{
        if(err)
            console.log(err);

        else{
            //fetch posts 
            var postsQuery=`SELECT * FROM posts ORDER BY id DESC`;
            var postsResult=await promiseQuery(postsQuery,con);
            console.log(postsResult);

            var slapsResult={}
            for(id=1;id<=postsResult.length;id++){
                slapsResult[id]=await fetchResponse(con,'slaps',id);
                
            }

            var clapsResult={};
            for(id=1;id<=postsResult.length;id++){
                clapsResult[id]=await fetchResponse(con,'claps',id);
                
            }

            var commentsResult={};
            for(id=1;id<=postsResult.length;id++){
                commentsResult[id]=await fetchResponse(con,'comments',id);
                
            }
            
            
           // console.log("thee slapss",slapsJson);
            return res.status(200).json({
                posts:postsResult,
                slaps:slapsResult,
                claps:clapsResult,
                comments:commentsResult
            });
        

        }
        con.release();
    });
});

router.post('/getImg',(req,res,next)=>{
    console.log("path......",req.body.path);
    res.sendFile(req.body.path);
});

//fetch directPosts
router.get('/getDirectPosts',(req,res,next)=>{
    pool.getConnection(async(err,con)=>{
        if(err)
            console.log(err);

        else{
            //fetch posts 
            var directPostsQuery=`SELECT post FROM directPosts ORDER BY id DESC`;
            var directPostsResult=await promiseQuery(directPostsQuery,con);
            console.log(directPostsResult);

            return res.status(200).json({
                posts:directPostsResult
            });
        }
    });
});

//--------------UPDATE CLAP----------------//

router.post('/clap',(req,res,next)=>{
    var userName=req.body.userName;
    var userEmail=req.body.userEmail;
    var postId=req.body.postId;
    var postType=req.body.postType;

    pool.getConnection((err,con)=>{
        if(err)
            console.log(err);

        else{
            //check if the user slapped the post, then delete the slap if any
            con.query(`select user_email from slaps WHERE user_email='${userEmail}'
            AND post_id='${postId}'`,function(err,result){
                if(err)
                    console.log(err);

                if(result!=0){
                    console.log('deleting  this response');
                    deleteEntry(con,'slaps',userEmail,postId);
                }
            });

            //check if the user had already clapped for the post
            con.query(`select user_email from claps WHERE user_email='${userEmail}'
            AND post_id='${postId}'`,function(err,result){
                if(err)
                    console.log(err);

                if(result!=0){
                    console.log('deleting this response');
                    deleteEntry(con,'claps',userEmail,postId);
                }

                else if(result==0){
                    var sql=`INSERT INTO claps(id,user_name,user_email,post_type,post_id)\
                    VALUES(null,'${userName}','${userEmail}','${postType}','${postId}')`;

                    console.log(sql);
                    con.query(sql,(err,result)=>{
                        if(err)
                            console.log(err);
                        
                    });
                }
            });

            
        }
    });
});

router.post('/slap',(req,res,next)=>{
    var userName=req.body.userName;
    var userEmail=req.body.userEmail;
    var postId=req.body.postId;
    var postType=req.body.postType;

    pool.getConnection((err,con)=>{
        if(err)
            console.log(err);

        else{
             //check if the user had  clapped for the post, delete the clap if any
             con.query(`select user_email from claps WHERE user_email='${userEmail}'
             AND post_id='${postId}'`,function(err,result){
                 if(err)
                     console.log(err);
 
                 if(result!=0){
                     console.log('deleting this response');
                     deleteEntry(con,'claps',userEmail,postId);
                 }
                });

            //check if the user already slapped this post
            con.query(`select user_email from slaps WHERE user_email='${userEmail}'
            AND post_id='${postId}'`,function(err,result){
                if(err)
                    console.log(err);

                if(result!=0){
                    console.log('deleting  this response');
                    deleteEntry(con,'slaps',userEmail,postId);
                }

                else if(result==0){
                    var sql=`INSERT INTO slaps(id,user_name,user_email,post_type,post_id)\
                    VALUES(null,'${userName}','${userEmail}','${postType}','${postId}')`;

                    console.log(sql);
                    con.query(sql,(err,result)=>{
                        if(err)
                            console.log(err);
                        
                    });
                }
            });
        }
    });
});

router.post('/comment',(req,res,next)=>{
    var userName=req.body.userName;
    var userEmail=req.body.userEmail;
    var postId=req.body.postId;
    var postType=req.body.postType;
    var comment=req.body.comment;

    pool.getConnection((err,con)=>{
        if(err)
            console.log(err);

        else{
            
            var sql=`INSERT INTO comments(id,user_name,user_email,post_type,post_id,comment)\
             VALUES(null,'${userName}','${userEmail}','${postType}','${postId}',"${comment}")`;

            console.log(sql);
            con.query(sql,(err,result)=>{
                if(err)
                    console.log(err);
                
            });
        }
    });
});

module.exports=router;
