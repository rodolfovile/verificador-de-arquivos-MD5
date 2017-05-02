require 'find'
require 'digest/md5'



unless ARGV[0] and File.directory?(ARGV[0])
	puts "\n\n\n voce precisa the um diretorio root: int.rb <directory>\n\n\n"
	exit
end


root = ARGV[0]
arquivo_velho_hash = Hash.new
novo_arquivo_hash = Hash.new
arquivo_report = "#{root}/repot_analise.txt"
arquivo_saida = "#{root}/lista_arquivo.txt"
arquivo_saida_velho = "#{root}/lista_arquivo.old"

if File.exists?(arquivo_saida)

	File.rename(arquivo_saida, arquivo_saida_velho)
	File.open(arquivo_saida_velho, 'rb') do |infile|
		while (temp = infile.gets)
			line = /(.+)\s{5,5}(\w{32,32})/.match(temp)
			puts "#{line[1]} --> #{line[2]}"
			arquivo_velho_hash[line[1]] = line[2]
		end
	end
end


Find.find(root) do |file| 
	next if /^\./.match(file)
	next unless File.file?(file)
	begin
		novo_arquivo_hash[file] = Digest::MD5.hexdigest(File.read(file))
	rescue
		puts "Erro ao ler #{file}, --MD5 não foi gerado"
	end
end


report = File.new(arquivo_report,'wb')
arquivos_modifcados = File.new(arquivo_saida,'wb')


novo_arquivo_hash.each do |file, md5|
	arquivos_modifcados.puts "#{file}       #{md5}"
end



novo_arquivo_hash.keys.select{|file| novo_arquivo_hash[file] == arquivo_velho_hash[file]}.each do |file|
	novo_arquivo_hash.delete(file)
	arquivo_velho_hash.delete(file)

end



novo_arquivo_hash.each do |file, md5|
	report.puts "#{arquivo_velho_hash[file] ? "changed" : "Added"} file: #{file} #{md5}"
	arquivo_velho_hash.delete(file)
end


arquivo_velho_hash.each do |file, md5| 
	report.puts "Deletado /Movido file: #{file}         #{md5}"
end

report.close()
arquivos_modifcados.close()
