#  Copyright (C) 2010-2012 Raivo Laanemets <raivo@infdot.com>
#
#  This file is part of infdot-build.
#  This file is part of infdot-upload.
#
#  Infdot-build is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Infdot-build is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with infdot-build.  If not, see <http://www.gnu.org/licenses/>.
 
class UploadController < ActionController::Base
  
  # Response has empty/nil error
  # message in the case of no error.
  
  class Response
    def initialize message
      @errorMessage = message
    end
  end
  
  # Handles the query for the file upload.
  
  def upload
    setup_essential_data params
    
    if @errors.empty?
      versions = @project.versions.select { |v| v.open? and version_is_current_build v }
        
      if versions.empty?
        @errors << "The project has no open version."
      end
      
      if versions.size > 1
        @errors << "The project must have single version marked for build."
      end
    end

    if @errors.empty?
      version = versions.first
    end
    
    if params[:file].nil?
      @errors << "The file to store is not sent."
    end
    
    if @errors.empty?
      # Duplicates sanitize_filename in attachment.rb
      original_name = params[:file].original_filename
      original_name = original_name.gsub(/^.*(\\|\/)/, '')
      original_name = original_name.gsub(/[^\w\.\-]/,'_')
      version.attachments.each do |a|
        if a.filename == original_name
          @errors << "The file already exists."
        end
      end
    end
    
    if @errors.empty?
      begin
        # There was a comment that Attachment#create might be moved into the model.
        a = Attachment.create(
          :container => version,
          :file => params[:file],
          :description => "", # Description is not shown under Files anyway.
          :author => @user)
        
        if a.new_record?
          @errors << "File was not saved."
        end
      rescue Exception => e
        @errors << "Cannot store file: #{e.message}."
      end
    end
    
    if @errors.empty?
      render :json => Response.new(nil)
    else
      render :json => Response.new(@errors.join(" "))
    end
  end
  
  private
  
  # Validates user name/password and project.
  # Checks if the user has permission to manage files.
  
  def setup_essential_data params
    @errors = []
    
    if params[:user].nil?
      @errors << "User name is not specified."
    end
    
    if params[:password].nil?
      @errors << "User password is not specified."
    end
    
    if params[:project].nil?
      @errors << "Project identifier is not specified."
    end
    
    if @errors.empty?
      @user = User.find_by_login params[:user]
      if @user.nil?
        @errors << "User name is invalid."
      else
        if !@user.check_password? params[:password]
          @errors << "Incorrect username/password."
        end
      end
    end
    
    if @errors.empty?
      @project = Project.find_by_identifier params[:project]
      if @project.nil?
        @errors << "Project name is invalid."
      end
    end
    
    if @errors.empty?
      if !can_upload_file @user, @project
        @errors << "No permissions to manage files."
      end
    end
  end
  
  # Checks whether the user has sufficient
  # permissions to manage files.
  
  def can_upload_file user, project
    roles = user.roles_for_project project
    can_upload = false
    roles.each do |r|
      can_upload ||= r.permissions.include? :manage_files
    end
  end
  
  def version_is_current_build version
    version.custom_values.each do |c|
      if c.custom_field.name == "Current build"
        if c.value == "1"
          return true
        end
      end
    end
    
    return false
  end
  
end
