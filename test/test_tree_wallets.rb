# frozen_string_literal: true

# Copyright (c) 2018 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'tmpdir'
require_relative '../lib/zold/key'
require_relative '../lib/zold/id'
require_relative '../lib/zold/tree_wallets'

# TreeWallets test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018 Yegor Bugayenko
# License:: MIT
class TestTreeWallets < Minitest::Test
  def test_adds_wallet
    Dir.mktmpdir do |dir|
      wallets = Zold::TreeWallets.new(dir)
      id = Zold::Id.new('abcd0123abcd0123')
      wallets.find(id) do |wallet|
        wallet.init(id, Zold::Key.new(file: 'fixtures/id_rsa.pub'))
        assert_equal(1, wallets.all.count)
        assert_equal(id.to_s, wallets.all[0])
        assert(wallet.path.end_with?('/a/b/c/d/abcd0123abcd0123.z'), wallet.path)
      end
    end
  end
end
