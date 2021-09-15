=begin
  Jekyll Hook that transform Kramdown links [link](http://exmample.com){:blank} into [link](http://exmample.com){:target="_blank"}

  This facilitates coding and avoids confusion with italic triggered with the underscore in _blank

  Applies to all pages and all posts in .md files
=end

require 'json'

# The index file we are generated
@pagesFile = "_site/pages.json"
# The array to which we add index entries
@pages = []
# A counter of documents for index id
@counter = 0

Jekyll::Hooks.register :site, :after_init do |site, payload|
    File.delete(@pagesFile) if File.exist?(@pagesFile)
    puts "Delete index file"
end
  
Jekyll::Hooks.register :site, :post_write do |site|
    puts "Writing index file"
    File.open(@pagesFile, "w") { |f| f.write @pages.to_json }
end

Jekyll::Hooks.register :pages, :post_render do |page|
    indexDoc(page)
end
  
Jekyll::Hooks.register :posts, :post_render do |post|
    indexDoc(post)
end

def build_url(permalink, lang)
    link = permalink
    if (lang && lang != 'en')
        link = "/#{lang}#{permalink}"
    end
    return link
end
  
def indexDoc(doc)

    docExt = doc.extname.tr('.', '')
    # only process if we deal with a markdown or html file
    return if (docExt != 'md' && docExt != 'html')

    docData = nil

    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    docData = doc.content.gsub!(re, '') if doc.content
    return if (!docData)

    #puts doc.content.gsub!(re, '') if doc.content

    page = Hash.new
    page['id'] = @counter
    page['title'] = doc.data['title']
    page['url'] = build_url(doc.data['permalink'], doc.data['lang'])
    page['body'] = docData
    page['lang'] = (doc.data['lang']) ? doc.data['lang'] : "en"
    @pages << page

    @counter += 1
end
  