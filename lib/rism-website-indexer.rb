=begin
  Jekyll Hook generates a pages.json file for indexing with lunr.js

  Applies to all pages and all posts in .md and .html files

  A page can be exlude from indexing with a skip_indexing: true in the frontmatter
  A page can be indexed in all languages with a index_all_lang: true in the frontmatter
=end

require 'json'

# The index file we are generated
@pagesFile = "_site/pages.json"
# The array to which we add index entries
@pages = []
# A counter of documents for index id
@counter = 0
# The site for accessing the site.active_lang status
@site = nil

Jekyll::Hooks.register :site, :after_init do |site, payload|
    File.delete(@pagesFile) if File.exist?(@pagesFile)
    puts "Delete index file"
    @site = site
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

def build_lang(lang)
    # when a page as index_all_lang, we need to rely on the @site.active_lang
    if @site 
        lang = @site.active_lang
    end
    # we need to prefix the lang because otherwise lunr drops them as stopwords
    langIndex = "xx"
    langIndex += (lang) ? lang : "en"
end
  
def indexDoc(doc)

    docExt = doc.extname.tr('.', '')
    # only process if we deal with a markdown or html file
    return if (docExt != 'md' && docExt != 'html')

    # skip excluded pages
    return if (doc.data['skip_indexing'])

    # index pages only when they are in their original language - except with index_all_lang
    return if (!doc.data['index_all_lang'] && @site && @site.active_lang != doc.data['lang'])
    
    docData = nil
    docTitle = doc.data['title']

    # remove html markup
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    docData = doc.content.gsub(re, '') if doc.content
    return if (!docData | !docTitle)
    # remove additional characters
    docData.gsub!("\n", " ")
    docData.gsub!("    ", " ")
    #docData.gsub!("”", " ")
    #docData.gsub!("“", " ")
    #docData.gsub!("‘", " ")   
    #docData.gsub!("’", " ") 
    docData.strip!
    docData.gsub!(/\s+/, " ")

    # remove characters from the title too
    docTitle.gsub!("    ", " ")
    #docTitle.gsub!("”", " ")
    #docTitle.gsub!("“", " ")
    #docTitle.gsub!("‘", " ")   
    #docTitle.gsub!("’", " ")   

    # create the json object for the index entry
    page = Hash.new
    page['id'] = @counter
    page['title'] = docTitle
    page['url'] = build_url(doc.data['permalink'], doc.data['lang'])
    page['body'] = docData
    page['lang'] = build_lang(doc.data['lang'])
    @pages << page

    @counter += 1
end
  