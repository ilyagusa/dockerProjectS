#!/usr/bin/env ruby
require 'optparse'

def checkd_run(*args, dir: nil)
    command = args.join(' ')
    if !dir.nil?
      command = "cd #{dir} && #{command}"
    end
    puts "Running #{command}"
    system(command)
end

def check_error(pathdir,pathback,method)
  unless (method == "zip" || method == "unzip")   
    puts "Метода [#{method}] не существует, запустите программу введя метод zip или unzip"
    exit(1)
  end

  unless (File.exist?(File.expand_path(pathdir)))
    puts "Введенный путь до главной директории не существует, введите правильный путь"
    exit(1)
  end

  unless (File.exist?(File.expand_path(pathback)))
    puts "Введеный путь до каталого в котром будет/должен лежать backup-архив не существует, введите правильный путь"
    exit(1)
  end
end


def zip(pathdir,pathback,method)
  name = nil
  absolutepathdir = File.expand_path(pathdir)
  absolutepathback = File.expand_path(pathback)
  if method == "zip"
    puts("Введите имя создаваемого архива с расширением tar(пример back.tar)")
    name = gets.chomp
    if(name=="exit")
    exit(1)
    end
    if !File.exist?(File.join(absolutepathback, name))
      checkd_run('sudo','rm','-rf','/tmp/currentbackup/')
      checkd_run('sudo','mkdir','/tmp/currentbackup/')
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'gitbucket','data'), '/tmp/currentbackup/gitbucket/')
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'kanboard','data'),'/tmp/currentbackup/kanboard/')
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'jenkins','data'),'/tmp/currentbackup/jenkins/') 
      checkd_run('sudo','tar','-cvf',File.join(absolutepathback,name),'/tmp/currentbackup/')
      checkd_run('sudo','rm','-rf','/tmp/currentbackup')
    else
      puts "Архив с таким именем существует, введите подходящее имя для создания нового архива"
      zip(pathdir,pathback,method)
    end
  elsif method == "unzip"
    puts("Введите имя архива с расширением tar, который нужно распаковать(пример back.tar)")
    name = gets.chomp
    if(name=="exit")
      exit(1)
    end
    if File.exist?(File.join(absolutepathback, name))
      checkd_run('sudo','rm','-rf', File.join(absolutepathdir,'gitbucket','data'))
      checkd_run('sudo','rm','-rf',File.join(absolutepathdir,'kanboard','data'))
      checkd_run('sudo','rm','-rf',File.join(absolutepathdir,'jenkins','data'))
      checkd_run('sudo','tar','-xvf',File.join(absolutepathback, name),'-C',File.join(absolutepathdir,'backup'))
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'backup','tmp','currentbackup','gitbucket'),File.join(absolutepathdir,'gitbucket','data'))
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'backup','tmp','currentbackup','kanboard'),File.join(absolutepathdir,'kanboard','data'))
      checkd_run('sudo','cp','-r',File.join(absolutepathdir,'backup','tmp','currentbackup','jenkins'),File.join(absolutepathdir,'jenkins','data'))
      checkd_run('sudo','rm','-rf',File.join(absolutepathdir,'backup','tmp'))
    else
      puts("Архива с введенным именем не существует, введите правильное имя")
      zip(pathdir,pathback,method)
    end
  end
end


if __FILE__ == $0
  options = {}
  OptionParser.new do |opt|
    opt.on('--pathdir PATHDIR') { |o| options[:pathd] = o }
    opt.on('--pathback PATHBACK') { |o| options[:pathb] = o }
    opt.on('--method METHOD') { |o| options[:method] = o }
  end.parse!
  if options.size != 3
    puts "pathdir - Путь до главной директории(в которой лежит папка backup)"
    puts "pathbackup - Путь до директории которая содержит/будет содержать backup-архив"
    puts "method - zip(заархивировать)/unzip(распаковать)"
    puts "Нужно ввести три параметра (--pathdir=pathdir,--pathback=pathback,--method=zip/unzip)"
  exit(1)
  end
  puts options
  check_error(options[:pathd],options[:pathb],options[:method])
  zip(options[:pathd],options[:pathb],options[:method])
end
