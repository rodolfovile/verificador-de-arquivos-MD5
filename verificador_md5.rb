require 'find'
require 'digest/md5'
# require 'trollop'

#Authors: @Vile, @Milhous3 

unless ARGV[0]
   abort( "\n\n\n voce precisa passar um diretorio ou arquivo: verficador_md5.rb <directory> <file>\n\n\n")
end


def checkArgv( path)
   if File.file? path
      checkFileIntegrite( path)
   end

   if File.directory? path
      parseDirectory( path)
   end
end


def checkFileIntegrite( filePath)
   if File.exists? filePath
      if File.file? filePath
         doIt( filePath)
      end
   end
end


def parseDirectory( dirPath)
   if Dir.exists? dirPath
      if File.directory? dirPath
         Dir.foreach(dirPath) do |mFile|
            checkFileIntegrite( mFile)
         end
      end
   end
end


def doIt( file)
   begin
		$novo_arquivo_hash[file] = Digest::MD5.hexdigest(File.read(file))
      writeLog
	rescue
		puts "Erro ao ler #{file}, --MD5 não foi gerado"
	end
end


def compareFile()
   if File.exists?($arquivo_saida)
      File.rename($arquivo_saida, $arquivo_saida_velho)
      File.open($arquivo_saida_velho, 'rb') do |infile|
         while (temp = infile.gets)
            line = /(.+)\s{5,5}(\w{32,32})/.match(temp)
            puts "#{line[1]} --> #{line[2]}"
            $arquivo_velho_hash[line[1]] = line[2]
         end
      end
   end
end


def writeLog()
   report = File.new($arquivo_report,'wb')
   arquivos_modifcados = File.new($arquivo_saida,'wb')

   $novo_arquivo_hash.each do |file, md5|
      arquivos_modifcados.puts "#{file}       #{md5}"
   end

   $novo_arquivo_hash.keys.select{|file| $novo_arquivo_hash[file] == $arquivo_velho_hash[file]}.each do |file|
      $novo_arquivo_hash.delete(file)
      $arquivo_velho_hash.delete(file)

   end

   $novo_arquivo_hash.each do |file, md5|
      report.puts "#{$arquivo_velho_hash[file] ? "modificado" : "adicionado"} file: #{file} #{md5}"
      $arquivo_velho_hash.delete(file)
   end

   $arquivo_velho_hash.each do |file, md5| 
      report.puts "Deletado /Movido file: #{file}         #{md5}"
   end

   report.close()
   arquivos_modifcados.close()
end


def main( path)
   $arquivo_velho_hash = Hash.new
   $novo_arquivo_hash = Hash.new
   $root = String.new

   if File.file? path
      $root = File.absolute_path(path).chomp(File.basename(path))
   else
      $root = path
   end

   $arquivo_report = "#{$root}report_analise.txt"
   $arquivo_saida = "#{$root}lista_arquivo.txt"
   $arquivo_saida_velho = "#{$root}lista_arquivo.old"

   compareFile
   checkArgv( path)
end


main( ARGV[0])


