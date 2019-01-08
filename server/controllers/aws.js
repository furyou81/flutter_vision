const AWS = require('aws-sdk');
const config = new AWS.Config({
    accessKeyId: "YOURS",
    secretAccessKey: "YOURS",
    region: "eu-west-1",
    bucket: "flutter-vision"
});
const fs = require("fs");
const rekognition = new AWS.Rekognition(config);
var dynamodb = new AWS.DynamoDB(config);


exports.analysis = async (req, res) => {
    console.log(req.body)

await fs.writeFileSync('image.png', req.body.image, {encoding: 'base64'});
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
    }




}