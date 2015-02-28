#  Copyright (C) 2010-2015 Raivo Laanemets, 2014 Jarosław Jeleniewicz
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

require 'redmine'

Redmine::Plugin.register :redmine_infdot_upload do
  name 'Infdot Upload'
  author 'Raivo Laanemets'
  description 'Release build management plugin'
  version '0.0.4'
end
