# sinatra upload image sample

## Upload Image

```sh
$ curl -X POST "http://localhost:4567/upload" -F "file=@sample.jpg"
```

```json
{
   "result":"Success",
   "requested_date":"2016-01-29 02:00:02 +0900",
   "uid":"58662d0cdb93e9bfde83c6199b6c50fd",
   "input":{
      "src_file":"sample.jpg"
   },
   "proc_result":{
      "result_img_url":"http://localhost:4567/res_img/58662d0cdb93e9bfde83c6199b6c50fd.jpg"
   }
}
```