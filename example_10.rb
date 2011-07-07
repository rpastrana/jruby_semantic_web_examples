require 'javalib/jena-2.6.4.jar'
require 'javalib/arq-2.8.7.jar'
require 'javalib/icu4j-3.4.4.jar'
require 'javalib/iri-0.8.jar'
require 'javalib/log4j-1.2.13.jar'
require 'javalib/lucene-core-2.3.1.jar'
require 'javalib/slf4j-api-1.5.8.jar'
require 'javalib/slf4j-log4j12-1.5.8.jar'
require 'javalib/stax-api-1.0.1.jar'
require 'javalib/wstx-asl-3.2.9.jar'
require 'javalib/xercesImpl-2.7.1.jar'
require 'java'

java_import 'com.hp.hpl.jena.rdf.model.ModelFactory'
java_import 'com.hp.hpl.jena.rdf.model.SimpleSelector'
java_import 'com.hp.hpl.jena.util.FileManager'
java_import 'com.hp.hpl.jena.vocabulary.VCARD'
java_import 'java.io.InputStream'

#Creating a model 
m = ModelFactory.create_default_model

#Finding the input file using the Jena File Manager
input_file = FileManager.get.open "sample_input.rdf"

#read the RDF/XML file
m.read(input_file, nil)

#select all the resources with a VCARD.FN property
iter = m.list_resources_with_property VCARD::FN
puts "The database contains vcards for:"
while iter.has_next
  puts iter.next_resource.get_required_property(VCARD::FN).get_string
end

#select all the resources with a VCARD.FN property whose value ends
#with Smith

class MySelector < SimpleSelector
  def selects(statement)
    if statement.get_string.include?("Smith")
      return true
    else
      return false
    end
  end
end


selector = MySelector.new(nil, VCARD::FN, nil)

#create a bag
smiths = m.create_bag

iter = m.list_statements(selector)
puts "When using a selector for Smith we get:"
while iter.has_next
  #add the smith to the bag
  smiths.add( iter.next_statement.get_subject)
end

puts "The whole model is "
m.write(java.lang.System::out)

iter = smiths.iterator
puts "The smiths in the bag collection are:"
while iter.has_next
  puts iter.next.string
end









