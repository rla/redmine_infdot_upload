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

RedmineApp::Application.routes.draw do
  post '/infdot_upload', :controller => 'infdot_upload', :action => 'upload'
end
