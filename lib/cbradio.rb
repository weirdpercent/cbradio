require 'multi_json'
#require 'nokogiri'
require 'open-uri/cached'
OpenURI::Cache.cache_path = 'tmp/open-uri' #transparent caching
#core/stdlib extensions
#classes
class CBRadio
  def pie(array, container, pa, percs)
    x=0
    y=array.length-1
    names=[]
    while x <= y
      hash=array[x]
      name=hash['name']
      val=hash['count']
      names.push name
      container.push val.to_f #let's float these bitches
      x+=1
    end
    total=container.reduce(:+).to_f
    x=0
    y=container.length-1
    while x <= y
      val=container[x]
      p=val / total
      p=(p*100).round #pies are round
      pa.push p
      x+=1
    end
    if pa.reduce(:+) > 100 then fix=pa.reduce(:+) - 100; pa[0]=pa[0] - fix; end #make sure the sum == 100
    if pa.reduce(:+) < 100 then fix=100 - pa.reduce(:+); pa[0]=pa[0] + fix; end
    x=0
    y=array.length-1
    while x <= y
      percs[names[x]]=pa[x]
      x+=1
    end
  end
  def perc(x, y, earned, badge)
    while x <= y
      z=badge[x]
      if z['earned'] == true then earned.push z; end
      x+=1
    end
  end
  def badge(x, y, earned)
    b=earned[x]
    bname=b['name']; bdesc=b['description']; blink=b['link']; bilink=b['image_link']; bdate=b['earned_date']; bd=Date.parse(bdate);
    blevel=b['level']; btrait=b['trait']; btdesc=b['trait_description']; bacc=b['account']; bissuer=bacc['name'];
    puts "Badge: #{bname}"
    puts "Description: #{bdesc}"
    puts "Link: #{blink}"
    puts "Image: #{bilink}"
    puts "Date Earned: #{bd}"
    puts "Level: #{blevel}"
    puts "Trait: #{btrait}"
    puts "Trait Description: #{btdesc}"
    puts "Badge Issuer: #{bissuer}\n\n"
  end
end
data=File.readlines('json/weirdpercent.json')
data=data.join
mjl=MultiJson.load(data)
#single values first
name=mjl['name']; uname=mjl['username']; title=mjl['title']; loc=mjl['location']; web=mjl['website_link']; bio=mjl['bio'];
since=mjl['created']; upd=mjl['updated']; views=mjl['views']; rank=mjl['rank']; link=mjl['link']; ghash=mjl['gravatar_hash'];
onebit=mjl['one_bit_badges']; eightbit=mjl['eight_bit_badges']; sixteenbit=mjl['sixteen_bit_badges'];
thirtytwobit=mjl['thirty_two_bit_badges']; sixtyfourbit=mjl['sixty_four_bit_badges']; followers=mjl['follower_count'];
following=mjl['following_count']
#now the arrays
tops=mjl['top_skills']; topl=mjl['top_languages']; tope=mjl['top_environments']; topf=mjl['top_frameworks']; topto=mjl['top_tools'];
topi=mjl['top_interests']; toptr=mjl['top_traits']; topa=mjl['top_areas']; badge=mjl['badges']; account=mjl['accounts'];
sumtops=[]; sumtopl=[]; sumtope=[]; sumtopf=[]; sumtopto=[]; sumtopi=[]; sumtoptr=[]; sumtopa=[];
cbr=CBRadio.new
#let's pie-chart these groups
pa=[]; percs={}; cbr.pie(tops, sumtops, pa, percs); skills=percs;
pa=[]; percs={}; cbr.pie(topl, sumtopl, pa, percs); languages=percs;
pa=[]; percs={}; cbr.pie(tope, sumtope, pa, percs); environments=percs;
pa=[]; percs={}; cbr.pie(topf, sumtopf, pa, percs); frameworks=percs;
pa=[]; percs={}; cbr.pie(topto, sumtopto, pa, percs); tools=percs;
pa=[]; percs={}; cbr.pie(topi, sumtopi, pa, percs); interests=percs;
pa=[]; percs={}; cbr.pie(toptr, sumtoptr, pa, percs); traits=percs;
pa=[]; percs={}; cbr.pie(topa, sumtopa, pa, percs); areas=percs;
#now for the badges
badge=mjl['badges']
x=0
y=badge.length-1
earned=[]
cbr.perc(x, y, earned, badge)
x=0
y=earned.length-1
while x <= y
  cbr.badge(x, y, earned)
  x+=1
end
