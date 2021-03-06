#!/usr/bin/env ruby
# Encoding: utf-8
#
# Author:: api.dklimkin@gmail.com (Danial Klimkin)
#
# Copyright:: Copyright 2011, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# Tests issue #31.

require 'gyoku'
require 'test/unit'

require 'ads_common/parameters_validator'
require 'adwords_api'
require 'adwords_api/v201309/targeting_idea_service_registry'

class TestIssue31 < Test::Unit::TestCase
  def setup()
    @registry =
        AdwordsApi::V201309::TargetingIdeaService::TargetingIdeaServiceRegistry
  end

  def run_test(selector)
    validator = AdsCommon::ParametersValidator.new(@registry)
    result_hash = validator.validate_args('get', [selector])
    return Gyoku.xml(result_hash)
  end

  def test_issue_31_single_xsi_type()
    selector = {
        :search_parameters => [
            {:xsi_type => 'RelatedToQuerySearchParameter',
             :queries => ['test']}
        ]
    }
    result_xml = run_test(selector)
    r = /searchParameters xsi:type="RelatedToQuerySearchParameter"/ =~
        result_xml
    assert_not_nil(r, 'Unable to find item with xsi_type ' +
        'RelatedToQuerySearchParameter')
  end

  def test_issue_31_multiple_xsi_types()
    selector = {
        :search_parameters => [
            {:xsi_type => 'CategoryProductsAndServicesSearchParameter',
             :category_id => 42},
            {:xsi_type => 'RelatedToQuerySearchParameter',
             :queries => ['test']}
        ]
    }
    result_xml = run_test(selector)
    r1 = /searchParameters xsi:type="CategoryProductsAndServicesSearchParameter"/ =~
        result_xml
    r2 = /searchParameters xsi:type="RelatedToQuerySearchParameter"/ =~
        result_xml
    assert_not_nil(r1, 'Unable to find item with xsi_type ' +
        'CategoryProductsAndServicesSearchParameter')
    assert_not_nil(r2, 'Unable to find item with xsi_type ' +
        'RelatedToQuerySearchParameter')
  end
end
