import wget


month_list=[


    '202401',
    '202402',
    '202403',
    '202404',
    '202405',
    '202406',
    '202407',
    '202408',
    '202409',
    '202410',
    '202411',
    '202412',
    '202501',
    '202502',
    '202503',
    '202504',
    '202505',
    '202506',
    '202507',
    '202508',
    '202509',
    '202510',
    '202511',
    '202512',
]

for i in month_list:

    url=f"https://divvy-tripdata.s3.amazonaws.com/{i}-divvy-tripdata.zip"

    file_name = wget.download(url,out = f'{i}.zip')




# https://divvy-tripdata.s3.amazonaws.com/202303-divvy-tripdata.zip