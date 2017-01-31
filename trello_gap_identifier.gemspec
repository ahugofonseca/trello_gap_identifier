$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name       = 'trello_gap_identifier'
  s.version    = '0.0.1'
  s.authors    = ['Hudson Ferreira', 'Hugo Abreu']
  s.email      = ['silvaferreira.hsf@gmail.com', 'a.hugofonseca@gmail.com']

  s.summary    = 'Identifies cards which spent more time to be done on each trello column than the average'

  s.files      = Dir['{lib}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_development_dependency 'bundler', '~> 1.13', '>= 1.13.6'
  s.add_development_dependency 'ruby-trello', '~> 1.5', '>= 1.5.1'
  s.add_development_dependency 'rspec', '~> 3.5'
end
