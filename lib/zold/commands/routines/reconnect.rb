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

require_relative '../remote'
require_relative '../../node/farm'

# Reconnect routine.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018 Yegor Bugayenko
# License:: MIT
module Zold
  # Routines module
  module Routines
    # Reconnect to the network
    class Reconnect
      def initialize(opts, remotes, farm = Farm::Empty.new, network: 'test', log: Log::Quiet.new)
        @opts = opts
        @remotes = remotes
        @farm = farm
        @network = network
        @log = log
      end

      def exec(_ = 0)
        sleep(60) unless @opts['routine-immediately']
        cmd = Remote.new(remotes: @remotes, log: @log, farm: @farm)
        args = ['remote', "--network=#{@opts['network']}"]
        score = @farm.best[0]
        args << "--ignore-node=#{score.host}:#{score.port}" if score
        cmd.run(args + ['add', 'b1.zold.io', '80']) unless @opts['routine-immediately']
        cmd.run(args + ['trim'])
        cmd.run(args + ['select'])
        cmd.run(args + ['update'] + (@opts['never-reboot'] ? [] : ['--reboot']))
        @log.info("Reconnected, there are #{@remotes.all.count} remote notes: \
#{@remotes.all.map { |r| "#{r[:host]}:#{r[:port]}" }.join(', ')}")
      end
    end
  end
end
