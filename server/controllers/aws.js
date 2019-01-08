const AWS = require('aws-sdk');
const conf = require('../conf');
const uniqid = require('uniqid');
const config = new AWS.Config({
    accessKeyId: conf.aws.accessKeyId,
    secretAccessKey: conf.aws.secretAccessKey,
    region: conf.aws.region,
    bucket: conf.aws.bucket
});
const fs = require("fs");
const rekognition = new AWS.Rekognition(config);
const dynamodb = new AWS.DynamoDB(config);
const s3 = new AWS.S3(config);

exports.analysis = async (req, res) => {
    console.log(req.body)
    if (req.body.image !== undefined && req.body.image !== "") {
        await fs.writeFileSync('image.png', req.body.image, { encoding: 'base64' });
        const bitmap = fs.readFileSync('image.png');
        const buffer = new Buffer.from(bitmap, 'base64')
        try {
            rekognition.searchFacesByImage({
                CollectionId: 'family_collection',
                Image: { Bytes: buffer }
            }, (err, data) => {
                console.log(err, data)
                const results = [];
                // data.FaceMatches.forEach(element => {
                const params = {
                    Key: {
                        RekognitionId: {
                            S: data.FaceMatches[0].Face.FaceId
                        }
                    },
                    TableName: "family_collection"
                };
                dynamodb.getItem(params, function (err, d) {
                    if (err) console.log(err, err.stack);
                    else {
                        console.log(d);
                        results.push({ confidence: data.FaceMatches[0].Similarity, people: d.Item.FullName.S });
                        res.status(200).json(results);
                    }
                });
                // });

            }
            )
        } catch (err) {
            console.log(err)
            res.status(400).json({ message: "error" })
        }
    } else {
        res.status(400).json({ message: "missing information" })
    }
}

exports.addToBucket = async (req, res) => {
    console.log(req.body)
    if (req.body.image !== undefined && req.body.image !== "" &&
        req.body.name !== undefined && req.body.name !== "") {
        await fs.writeFileSync('image.png', req.body.image, { encoding: 'base64' });
        const bitmap = fs.readFileSync('image.png');
        const buffer = new Buffer.from(bitmap, 'base64')
        var params = {
            Body: buffer,
            Bucket: conf.aws.bucket,
            Key: `index/${uniqid()}`,
            Metadata: {
                'FullName': req.body.name
            }
        };
        s3.putObject(params, function (err, data) {
            if (err) {
                console.log(err, err.stack); // an error occurred
                res.status(400).json({ message: "error" })
            } else {
                console.log(data);           // successful response
                console.log("OK")
                res.status(200).json({ message: "added to bucket" })
            }
            /*
            data = {
             ETag: "\"6805f2cfc46c0f04559748bb039d69ae\"", 
             VersionId: "Bvq0EDKxOcXLJXNo_Lkz37eM3R4pfzyQ"
            }
            */
        });
    } else {
        res.status(400).json({ message: "missing information" })
    }
}