#!/usr/bin/env ruby
require 'smugsyncv2'
require 'fileutils'
require 'open-uri'
require 'tmpdir'
require 'thor'

class DownloadTaggedSmugmugPhotosHelper
  def self.download(url, dest)
    uri = URI.parse(url)
    dest_file = File.basename(uri.path)
    dest_path = File.join(dest, dest_file)
    puts "Downloading #{dest_file}..."
    File.open(dest_path, 'wb') do |saved_file|
      # the following "open" is provided by open-uri
      open(url, 'rb') do |read_file|
        saved_file.write read_file.read
      end
    end
  end
end

class DownloadTaggedSmugmugPhotos < Thor

  desc 'download tagged images from SmugMug', 'download OPTIONS'
  option :key, required: true, type: :string, banner: 'This is the SmugMug API key.  Can be found at: https://secure.smugmug.com/settings/#section=api-keys'
  option :secret, required: true, type: :string, banner: 'This is the SmugMug API secret key.  Can be found at: https://secure.smugmug.com/settings/#section=api-keys'
  option :tags, required: true, type: :array, banner: 'These are the tagged images you wish to download'
  option :dest, required: false, type: :string, default: Dir.mktmpdir
  option :logging, required: false, type: :boolean, default: false
  def download
    FileUtils.mkdir_p options[:dest] unless File.exist? options[:dest]
    client = Smugsyncv2::Client.new(options[:key], options[:secret], options[:logging])
    client.user
    search = client.get_uri('UserImageSearch')
    search_uri = search.Response.Uri
    param_name = search.Options.Parameters.GET.find { |n| n.respond_to? :Name }.Name

    puts "Downloading into #{options[:dest]}"
    options[:tags].each do |tag|
      params = { param_name => tag }
      image_search_response = client.request(path: search_uri, params: params)
      images = image_search_response.Response.Image
      images.each do |image|
        image_uri = image.Uris.LargestImage.Uri
        image_response = client.request(path: image_uri)
        image_download_url = image_response.Response.LargestImage.Url
        DownloadTaggedSmugmugPhotosHelper.download(image_download_url, options[:dest])
      end
      puts "Downloaded #{images.length} images into #{options[:dest]}"
    end
  end
end

DownloadTaggedSmugmugPhotos.start(ARGV)
