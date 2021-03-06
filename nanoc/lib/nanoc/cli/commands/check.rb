# frozen_string_literal: true

usage 'check [options] [names]'
summary 'run issue checks'
description "
Run issue checks on the current site. If the `--all` option is passed, all available issue checks will be run. By default, the issue checks marked for deployment will be run.
"

flag :a, :all,    'run all checks'
flag :L, :list,   'list all checks'
flag :d, :deploy, '(deprecated)'

module Nanoc::CLI::Commands
  class Check < ::Nanoc::CLI::CommandRunner
    def run
      site = load_site

      runner = Nanoc::Checking::Runner.new(site)

      if options[:list]
        runner.list_checks
        return
      end

      success =
        if options[:all]
          runner.run_all
        elsif options[:deploy]
          runner.run_for_deploy
        elsif arguments.any?
          runner.run_specific(arguments)
        else
          runner.run_for_deploy
        end

      unless success
        raise Nanoc::Int::Errors::GenericTrivial, 'One or more checks failed'
      end
    end
  end
end

runner Nanoc::CLI::Commands::Check
