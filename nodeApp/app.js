const express= require('express');
const app=express();
const morgan=require('morgan');
const bodyParser=require('body-parser');
const userRoutes=require('./API/routes/user');
const postRoutes=require('./API/routes/posts');

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());

app.use((req,res,next)=>{
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers','Origin,X-Requested-With,\
     Content-Type, Accept, Authorization');
    if(req.method==='OPTIONS'){
        res.header('Access-Control-Allow-methods', 'PUT,POST, DELETE,\
        PATCH,GET');
        return res.status(200).json({});
    }
    next();//this will not block incoming requests
});

//setup routes:
app.use('/user',userRoutes);
app.use('/posts',postRoutes);

//whenever an error is thrown this method will be triggered
app.use((req,res,next)=>{
    const error=new Error('Not Found');
    error.status=404;
    next(error);
});

app.use((error,req,res,next)=>{
    res.status(error.status|| 500).json({
        error:{
            message:error.message,
        }
    });
});

module.exports=app;