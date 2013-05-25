Capistrano::Configuration.instance(true).load do
  task :check_for_ssh_agent do
    pid = ENV["SSH_AGENT_PID"]
    raise %|No ssh-agent active (cannot authenticate to bitbucket/github without it.) Try running "eval `ssh-agent`; ssh-add".| if pid.nil? or pid == "" or pid.to_i == 0

    begin
      Process.getpgid(pid.to_i)
    rescue Errno::ESRCH
      raise %|The ssh-agent at pid #{pid} has died (cannot authenticate to bitbucket/github without it.) Try running "eval `ssh-agent`; ssh-add".|
    end

    if `ssh-add -L` =~ /no identities/
      raise %|The ssh-agent at pid #{pid} has no keys. Have you run "ssh-add"?|
    end
  end
  before "deploy:update", "check_for_ssh_agent"
end
