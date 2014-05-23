mongoose = require 'mongoose'
Schema   = mongoose.Schema
ObjectId = Schema.Types.ObjectId

express  = require 'express'

Buffer   = require 'buffer'

mongoose.connect 'mongodb://localhost/shunt', (err, res) ->
    console.log(err) if err?

action_schema = new Schema
    user_id: ObjectId
    data: Buffer

download_schema = new Schema
    user_id: ObjectId
    data: Buffer

user_schema = new Schema
    login: String
    pass: String

Action   = mongoose.model 'Action', action_schema
Download = mongoose.model 'Download', download_schema
User     = mongoose.model 'User', user_schema

app = express()

app.use express.basicAuth (user, pass, callback) ->
    User.findOne {user, pass}, (err, res) ->
        callback(false) if err?
        callback(true) if not err?

app.put '/user', (req, res, next) ->
    user = new User
        login: req.body.login
        pass: req.body.pass
    user.save()
    res.send 'ok'

app.listen 8080
