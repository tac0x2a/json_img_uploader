#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'digest/md5'

# static contents
PublicDir = File.dirname(__FILE__) + "/public"
set :public_dir, PublicDir

ResultImagePath = "/res_img"
UploadedImgDir   = "uploaded_img"


# Save Uploaded Img as Temp File
def save_uploaded_file(params, uid)
  raise "No input image" unless params[:file]
  raise "No input image - Failed to create tempfile" unless params[:file][:tempfile]
  raise "No input image - No filename" unless params[:file][:filename]

  file_name = params[:file][:filename]
  input_data = {src_file: file_name }

  ext = File.extname(params[:file][:tempfile].path)
  save_path = "./#{UploadedImgDir}/#{uid}#{ext}"

  File.open(save_path, 'wb') do |f|
    f.write params[:file][:tempfile].read
  end

  [save_path, input_data]
end

# Process File
def process_file(input_file_path)

  out_file_name = File.basename(input_file_path)
  out_file_path = ResultImagePath + '/' + out_file_name
  `mv #{input_file_path} #{PublicDir}#{out_file_path}`

  url = url(out_file_path)
  proc_result = {result_img_url: url}

  [out_file_path, proc_result]
end


post '/process_image' do
  utime = Time.now.to_s + rand.to_s
  uid = Digest::MD5.new.update(Time.now.to_s + rand.to_s).to_s

  data = { result: "Success", requested_date: Time.now.to_s, uid: uid}

  begin
    input_file_path, input_data = save_uploaded_file(params, uid)
    data[:input] = input_data

    # some process... and generate processed image file.
    out_file_path, proc_result = process_file(input_file_path)
    data[:proc_result] = proc_result
    data[:result]  = "Success"

  rescue => e
    data[:result]  = "Failed"
    data[:message] = e.to_s
  end

  json data
end
