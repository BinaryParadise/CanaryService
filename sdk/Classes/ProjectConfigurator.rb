require 'xcodeproj'
require 'yaml'
require 'json'
require 'net/http'

BUILD_PHASE_NAME_FETCH_ENV = '[MC] Fetch Remote Config'
BUILD_PHASE_VERION  = '1'

class ProjectConfigurator
  attr_accessor :ruby_path  #本地开发模式路径

  def self.configure_project(installer, appkey, url)
    podspec = installer.sandbox.development_pods['MCFrontendKit']
    @ruby_path = podspec ? podspec.dirname.to_s+"/sdk" : "Pods"

    installer.analysis_result.targets.each do |target|
      if target.user_project_path.exist? && target.user_target_uuids.any?
        project = Xcodeproj::Project.open(target.user_project_path)
        project_targets = self.project_targets(project, target)
        self.add_shell_script(project_targets, project, target, appkey, url)
      end

    end

  end

  def self.add_shell_script(project_targets, project, target, appkey, url)
    install_targets = project_targets.select { |target| target.product_type == 'com.apple.product-type.application' }
    install_targets.each do |project_target|
      if appkey.nil?
        project_target.build_configurations.first.build_settings.each do |config|
          if config[0] == 'PRODUCT_BUNDLE_IDENTIFIER'
            appkey = config[1]
          end
        end
      end

      rubyfile = @ruby_path + "/Classes/ProjectConfigurator.rb"

      phase = self.fetch_exist_phase(BUILD_PHASE_NAME_FETCH_ENV, project_target)
      if phase.nil?
        phase = project_target.new_shell_script_build_phase(BUILD_PHASE_NAME_FETCH_ENV)
      end

      phase.comments = BUILD_PHASE_VERION
      phase.shell_script = 'if [ "$CONFIGURATION" != "Release" ]; then
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
ruby "'+rubyfile+'" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}${WRAPPER_SUFFIX}" "'+appkey+'" '+url+'
fi'
      project.save()
    end

  end

  def self.project_targets(project, target)
    project_targets = Array.new

    target.user_target_uuids.each do |user_target_uuid|
      project.targets.each do |project_target|
        if project_target.uuid.eql? user_target_uuid
          project_targets.push(project_target)
        end
      end
    end

    return project_targets
  end

  #判断是否已存在
  def self.fetch_exist_phase(phase_name, project_target)
    project_target.build_phases.each do |build_phase|
      next if build_phase.display_name != phase_name
      #build_phase.remove_from_project
      return build_phase
    end
    return nil
  end
end

class DefaultEnvFetcher
  def self.fetch_default_env_table(destination_directory, appkey, url)
    if destination_directory.eql?("install")
      return
    end

    destination_directory += '/Peregrine.bundle'

    if !File.exists?(destination_directory)
      Dir.mkdir(destination_directory)
    end

    default_routing_table_destination_file = destination_directory + '/RemoteConfig.json'
    start_time = DefaultEnvFetcher::start_fetching(default_routing_table_destination_file)
    DefaultEnvFetcher::fetch_to(default_routing_table_destination_file, appkey, url)

    DefaultEnvFetcher::end_fetching(start_time)
  end

  def self.fetch_to(destination_file, appkey, url)    
    begin
      getURI = URI.parse(url+"/api/conf/full?appkey=#{appkey}&os=iOS")
      puts "GET "+getURI.to_s
      response = Net::HTTP.get_response(getURI)
      puts "body: #{response.body}"
    
      if response.code == "301"
        response = Net::HTTP.get_response(URI(response['location']))
      end
    rescue Exception => e
      puts "\033[31m#{e.message}\033[0m\n"
      return
    end

    response_code = response.code.to_i
    if response_code < 200 or response_code > 299
      puts "`network error, code: #{response_code}, #{response.body}`"
    end

    begin
      response_body = JSON.parse(response.body + '')

      code = response_body['code'].to_i
      error = response_body['error']
      if code != 0
        puts "`request error, code: #{code}, error: #{error}`"
      end
    
      data = response_body['data']
      default_routing_table_json_file = File.new("#{destination_file}", 'w+')
      default_routing_table_json_file.write(data.to_json)
      default_routing_table_json_file.close

    rescue JSON::ParserError => e
      puts "response error, invalid json string: #{response.body}"
    end
  end

  def self.start_fetching(destination_file)
    puts 'fetching default routing table'
    puts 'writing to'
    puts destination_file

    Time.now
  end

  def self.end_fetching(start_time)
    puts 'done 🍻'
    puts "total fetch time is #{Time.now - start_time}s"
  end

end

DefaultEnvFetcher::fetch_default_env_table(ARGV[0], ARGV[1], ARGV[2])
