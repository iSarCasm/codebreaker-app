namespace :db do
  task :setup do
    Dir.mkdir("db") unless Dir.exist?("db")
    File.open("./db/records.yml","a")
  end

  task :drop do
    File.delete("./db/records.yml")
  end
end
