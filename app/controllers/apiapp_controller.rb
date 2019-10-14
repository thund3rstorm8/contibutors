require 'net/http'
require 'json'
require 'prawn'
require 'digest/md5'
require 'zip'     

class ApiappController < ApplicationController
  def home
    
  end
  
  def download
    send_file "#{Rails.root}/storage/#{request.parameters['path']}", :disposition => 'attachment'
  rescue
    render json: {
      error: "smth wrong"
    }, status: :not_found
  end

  def result
    if request.parameters['search'].blank? || !/https:\/\/github\.com\/[\w\d\-\_\/]{1,}/.match(request.parameters['search'])
      redirect_to :home
    else
      puts link = request.parameters['search'].scan(/[https:\/github\.com]{1,}(\/[a-zA-Z0-9_\-]{1,}\/[a-zA-Z0-9_\-]{1,})/)[0][0]
      uri = URI("https://api.github.com/repos#{link}/contributors")
      con = JSON.parse(Net::HTTP.get(uri))
      @link = request.parameters['search']
      @contrib = []
      place = 1
      temptime = Digest::MD5.hexdigest(Time.now.iso8601)
      system("mkdir storage/#{temptime}")
      folder = "#{Rails.root}/storage/#{temptime}"
      zipname = "#{Rails.root}/storage/#{temptime}/archive.zip"
      @archive = "#{temptime}/archive.zip"
      con[0..2].each do |a|
          a.to_hash
          temp = Hash.new
          safe_name = Digest::MD5.hexdigest(a['login'])
          temp['1'] = a['login']
          temp['2'] = a['url'].sub(/api\./, "").sub(/users\//,"")
          temp['3'] = a['contributions']
          temp['link'] = "#{temptime}/#{safe_name}.pdf"
          temp['place'] = place
          @contrib << temp
          Prawn::Document.generate("storage/#{temptime}/#{safe_name}.pdf") do
          text "repo: #{uri}"
          text "GREATING YOU WITH #{place} PLACE"
          text "------------------"
          text "name: #{a['login']}"
          text "link to Github profile #{a['url']}"
          text "Times contibuted: #{a['contributions']}"
          end
          place += 1
        end
      Zip::File.open(zipname, Zip::File::CREATE) do |zipfile|
        Dir::chdir(folder) {
          files = Dir["*.*"]
          files.each do |file|
            zipfile.add( file, File.expand_path(file) )
          end
        }
      end
    end
  end  
  rescue
  render json: {
    error: "smth wrong"
  }, status: :not_found
end