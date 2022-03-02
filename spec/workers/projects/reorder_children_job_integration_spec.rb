#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

describe Projects::ReorderChildrenJob, type: :model do
  subject(:job) { described_class.perform_now }

  shared_let(:parent_project) { create(:project, name: 'Parent') }

  shared_let(:child_a) { create :project, name: 'A', parent: parent_project }
  shared_let(:child_b) { create :project, name: 'B', parent: parent_project }
  shared_let(:child_c) { create :project, name: 'C', parent: parent_project }

  let(:ordered) { parent_project.children.reorder(:lft) }

  before do
    # Update the names
    child_a.update_column(:name, 'Second')
    child_b.update_column(:name, 'Third')
    child_c.update_column(:name, 'First')
  end

  it 'corrects the order' do
    expect(ordered.pluck(:name)).to eq %w[Second Third First]

    subject

    expect(ordered.reload.pluck(:name)).to eq %w[First Second Third]
  end
end
