import boto3

s3 = boto3.resource('s3')

# Get list of objects for indexing
images=[('7.jpg','Ryo'),
      # ('2.jpg','Albert Einstein'),
      # ('3.jpg','Albert Einstein'),
      # ('4.jpg','Mark Zuckerberg'),
      # ('5.jpg','Mark Zuckerberg'),
      # ('6.jpg','Mark Zuckerberg')
      ]

# Iterate through list to upload objects to S3   
for image in images:
    file = open(image[0],'rb')
    object = s3.Object('flutter-vision','index/'+ image[0])
    ret = object.put(Body=file,
                    Metadata={'FullName':image[1]}
                    )
