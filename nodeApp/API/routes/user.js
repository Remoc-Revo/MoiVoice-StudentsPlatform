const express=require('express');
const router=express.Router();
const db=require('../../core/db');
const mysql=require('mysql');
const bcrypt=require('bcrypt');
const jwt=require('jsonwebtoken');


const pool= db.pool;
    

router.post('/signUp',(req,res,next)=>{
    var userEmail=req.body.userEmail;
    var userPassword= req.body.userPassword;
    var userName= req.body.userName ;
    var userPhone=req.body.userPhone;
    var userAdmission=req.body.userAdmission ;

    if((userEmail!=null)&&(userPassword!=null)&&(userName!=null)&&
        (userPhone!=null)&&(userAdmission!=null)
    ){
        bcrypt.hash(req.body.userPassword,10,async(err,hash)=>{
            if(err){
                return res.status(500).json({
                    error:{
                        message:err
                    }
                });
            }
            else{
                pool.getConnection((err,con)=>{
                    if(!err){
                        console.log('connection established successfully');
                    
                        con.query(`SELECT email FROM users WHERE email='${userEmail}'`,
                                function(error,result){
                                    if(error){
                                        res.status(500).json({
                                            error:{
                                                message:error
                                            }
                                        });
                                    }
                                     if(result!=0){
                                        return res.status(500).json({
                                            error:{
                                                message:'email exists'
                                            }
                                        });
                                    }

                                    else{
                                        var sql=`INSERT INTO users(id,user_id,user_name,adm_number,email,password,\
                                            phone_number) VALUES(null,0,'${userName}','${userAdmission}','${userEmail}',\
                                            '${hash}','${userPhone}') `;
                        
                                        console.log(sql);
                        
                                        con.query(sql,function(error,result){
                                            if(error){
                                                res.status(500).json({
                                                    error:{
                                                        message:error
                                                    }
                                                });
                                                console.log(error);
                                            }
                                            else
                                                console.log('registered successfully');

                                                

                                                return res.status(200).json({
                                                    message: 'success',
                                
                                                });
                                        });
                                    }

                                });
                        
                    }
                    else
                        console.log('connection failed'+JSON.stringify(err,undefined,2));
                con.release();
                });
                
            }
        });
    }
    else{
        return res.status(422).json({
            error:{
                message:'some parameters not supplied'
            }
        });
    }
});

router.post('/signIn', async(req,res,next)=>{
    console.log('server called');
    var userEmail=req.body.userEmail;
    var userPassword= req.body.userPassword;

    if(req.body.userEmail!=null&&req.body.userPassword!=null){
        
        pool.getConnection((err,con)=>{
            if(err){
                res.status(500).json({
                    error:{
                        message:err
                    }
                });
            }
            else{
                var sql=`SELECT * FROM users WHERE email='${userEmail}'`;
                console.log(sql);
                con.query(sql,function(err,result){
                    if(err){
                        console.log(err);
                        return res.status(500).json({
                            error:{
                                message:err
                            }
                        });
                        
                    }
                    console.log(result);
                    
                    if(result!=0){
                        console.log(result);
                        console.log("passwor",result[0]['password']);

                        //compare the entered password with the one in stored in the database
                        bcrypt.compare(userPassword,result[0]['password'],
                            (err,data)=>{
                                if(err){
                                    return res.status(500).json({
                                        error:{
                                            message:err
                                        }
                                    });
                                }
                                //if the passwod matches
                                if(data){
                                    const token=jwt.sign({
                                        email:result[0]['email'],
                                        userId:result[0]['id']
                                        },
                                        "secret",
                                        {
                                            expiresIn:'1h'
                                        },
                                    );
                                    console.log(result);

                                    return res.status(200).json({
                                        message: 'success',
                                        userdata:result[0],
                                        access_token:token,
                                        userDetails:{
                                            name:result[0]['user_name'],
                                            admission:result[0]['adm_number'],
                                            phone:result[0]['phone_number'].toString(),
                                            user_id:result[0]['user_id'].toString()
                                        }
                                    });
                                }
                                return res.status(404).json({
                                    error:{
                                        message:'Auth Failed: incorrect password or email'
                                    }
                                });
                            }
                        );
                    }
                    else if(result==0){
                        return res.status(404).json({
                            error:{
                                message:'Auth Failed: incorrect password or email'
                            }
                        });
                    }
                });
            }
        con.release();
            
        });
    }
    else{
        return res.status(422).json({
            error:{
                message:' Parameter not supplied'
            }
        });
    }
});

module.exports=router;

