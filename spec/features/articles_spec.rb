# frozen_string_literal: true

require "rails_helper"
require "yaml"
include ApplicationHelper

RSpec.feature "Articles Search" do

  let(:response_body) { default_articles_response_body }

  before(:each) do
    stub_request(:get, /primo/).
      to_return(status: 200,
                headers: { "Content-Type" => "application/json" },
                body: response_body)
  end

  scenario "Search" do
    visit "/articles"
    fill_in "q", with: "foo"
    click_button "search"
    expect(current_url).to eq "http://www.example.com/articles?utf8=%E2%9C%93&search_field=any&q=foo"
    expect(page).to have_css("#facets")
    within(".document-position-0 h3") do
      expect(page).to have_text("Test")
    end
    within first(".document-metadata") do
      expect(page).to have_text "Is Part Of:"
      expect(page).to have_text "Author/Creator"
      expect(page).to have_text "Resource Type"
      expect(page).to have_text "Year"
      has_css?(".avail-button", visible: true)
    end
  end

  scenario "advanced search followed by plain search" do
    visit "/articles/advanced"
    fill_in "q_1", with: "foo"
    fill_in "q_2", with: "bar"
    click_button "advanced-search-submit"
    expect(current_url).to match /q_1=foo/
    expect(current_url).to match /q_2=bar/
    fill_in "q", with: "cat"
    click_button "search"
    expect(current_url).to match /q=cat/
    expect(current_url).not_to match /q_1=foo/
    expect(current_url).not_to match /q_2=bar/
  end

  def default_articles_response_body
    "{\"highlights\":{\"recordid\":[\"gvrl_refCX1959400467\"],\"creator\":[\"gvrl_refcx1959400467\"],\"contributor\":[\"gvrl_refcx1959400467\"],\"vertitle\":[\"gvrl_refcx1959400467\"],\"termsUnion\":[\"gvrl_refcx1959400467\"],\"title\":[\"gvrl_refcx1959400467\"]},\"docs\":[{\"enrichment\":{\"virtualBrowseObject\":{\"callNumber\":\"\",\"isVirtualBrowseEnabled\":false,\"callNumberBrowseField\":\"browse_callnumber\"}},\"delivery\":{\"availabilityLinks\":[\"detailsGetit1\"],\"physicalItemTextCodes\":\"\",\"displayLocation\":false,\"availabilityLinksUrl\":[\"\"],\"link\":[{\"displayLabel\":\"openurl\",\"inst4opac\":\"01TULI\",\"linkURL\":\"http://1.1.1.1?ctx_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8&ctx_tim=2019-02-08T12%3A37%3A26IST&url_ver=Z39.88-2004&url_ctx_fmt=infofi/fmt:kev:mtx:ctx&rfr_id=info:sid/primo.exlibrisgroup.com:primo3-Article-gvrl_ref&rft_val_fmt=info:ofi/fmt:kev:mtx:journal&rft.genre=article&rft.atitle=Test&rft.jtitle=&rft.btitle=&rft.aulast=Apanasovich&rft.auinit=V.&rft.auinit1=&rft.auinitm=&rft.ausuffix=&rft.au=Apanasovich,%20Tatiyana%20V.&rft.aucorp=&rft.date=2010&rft.volume=&rft.issue=&rft.part=&rft.quarter=&rft.ssn=&rft.spage=1494&rft.epage=1495&rft.pages=1494-1495&rft.artnum=&rft.issn=&rft.eissn=&rft.isbn=978-1-4129-6128-8&rft.sici=&rft.coden=&rft_id=info:doi/&rft.object_id=&rft_dat=%3Cgvrl_ref%3ECX1959400467%3C/gvrl_ref%3E%3Cgrp_id%3E-8443850069020496193%3C/grp_id%3E%3Coa%3E%3C/oa%3E%3Curl%3E%3C/url%3E&rft.eisbn=&rft_id=info:oai/&rft_pqid=&rft_id=info:pmid/&rft_galeid=CX1959400467&rft_cupid=&rft_eruid=&rft_nurid=&rft_ingid=\",\"linkType\":\"http://purl.org/pnx/linkType/openurl\",\"@id\":\"_:0\"},{\"displayLabel\":\"openurlfulltext\",\"inst4opac\":\"01TULI\",\"linkURL\":\"http://1.1.1.1?ctx_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8&ctx_tim=2019-02-08T12%3A37%3A26IST&url_ver=Z39.88-2004&url_ctx_fmt=infofi/fmt:kev:mtx:ctx&rfr_id=info:sid/primo.exlibrisgroup.com:primo3-Article-gvrl_ref&rft_val_fmt=info:ofi/fmt:kev:mtx:journal&rft.genre=article&rft.atitle=Test&rft.jtitle=&rft.btitle=&rft.aulast=Apanasovich&rft.auinit=V.&rft.auinit1=&rft.auinitm=&rft.ausuffix=&rft.au=Apanasovich,%20Tatiyana%20V.&rft.aucorp=&rft.date=2010&rft.volume=&rft.issue=&rft.part=&rft.quarter=&rft.ssn=&rft.spage=1494&rft.epage=1495&rft.pages=1494-1495&rft.artnum=&rft.issn=&rft.eissn=&rft.isbn=978-1-4129-6128-8&rft.sici=&rft.coden=&rft_id=info:doi/&rft.object_id=&svc_val_fmt=info:ofi/fmt:kev:mtx:sch_svc&svc.fulltext=yes&rft_dat=%3Cgvrl_ref%3ECX1959400467%3C/gvrl_ref%3E%3Cgrp_id%3E-8443850069020496193%3C/grp_id%3E%3Coa%3E%3C/oa%3E%3Curl%3E%3C/url%3E&rft.eisbn=&rft_id=info:oai/&rft_pqid=&rft_id=info:pmid/&rft_galeid=CX1959400467&rft_cupid=&rft_eruid=&rft_nurid=&rft_ingid=\",\"linkType\":\"http://purl.org/pnx/linkType/openurlfulltext\",\"@id\":\"_:1\"},{\"displayLabel\":\"thumbnail\",\"linkURL\":\"no_cover\",\"linkType\":\"http://purl.org/pnx/linkType/thumbnail\",\"@id\":\"_:2\"}],\"availability\":[\"fulltext\"],\"additionalLocations\":false,\"displayedAvailability\":\"fulltext\",\"holding\":[],\"deliveryCategory\":[\"Remote Search Resource\"],\"serviceMode\":[\"activate\"],\"feDisplayOtherLocations\":false,\"GetIt1\":[{\"links\":[{\"isLinktoOnline\":true,\"displayText\":\"Almaviewit_remote\",\"hyperlinkText\":\"\",\"getItTabText\":\"alma_tab1_full\",\"link\":\"https://temple.userservices.exlibrisgroup.com/view/uresolver/01TULI_INST/openurl?ctx_enc=info:ofi/enc:UTF-8&ctx_id=10_1&ctx_tim=2019-02-08T12%3A37%3A26IST&ctx_ver=Z39.88-2004&url_ctx_fmt=info:ofi/fmt:kev:mtx:ctx&url_ver=Z39.88-2004&rfr_id=info:sid/primo.exlibrisgroup.com-gvrl_ref&req_id=&rft_val_fmt=info:ofi/fmt:kev:mtx:journal&rft.genre=article&rft.atitle=Test&rft.jtitle=&rft.btitle=&rft.aulast=Apanasovich&rft.auinit=V.&rft.auinit1=&rft.auinitm=&rft.ausuffix=&rft.au=Apanasovich,%20Tatiyana%20V.&rft.aucorp=&rft.date=2010&rft.volume=&rft.issue=&rft.part=&rft.quarter=&rft.ssn=&rft.spage=1494&rft.epage=1495&rft.pages=1494-1495&rft.artnum=&rft.issn=&rft.eissn=&rft.isbn=978-1-4129-6128-8&rft.sici=&rft.coden=&rft_id=info:doi/&rft.object_id=&rft.eisbn=&rft.edition=&rft.pub=&rft.place=&rft.series=&rft.stitle=&rft.bici=&rft_id=info:bibcode/&rft_id=info:hdl/&rft_id=info:lccn/&rft_id=info:oclcnum/&rft_id=info:pmid/&rft_id=info:eric/((addata/eric}}&rft_dat=%3Cgvrl_ref%3ECX1959400467%3C/gvrl_ref%3E,language=eng,view=TULI&svc_dat=viewit&rft.local_attribute=&rft.kind=&rft_pqid=&rft_galeid=CX1959400467&rft_cupid=&rft_eruid=&rft_nurid=&rft_ingid=\",\"@id\":\"_:0\"}],\"category\":\"Remote Search Resource\"}]},\"context\":\"PC\",\"adaptor\":\"primo_central_multiple_fe\",\"pnx\":{\"delivery\":{\"fulltext\":[\"fulltext\"],\"delcategory\":[\"Remote Search Resource\"]},\"search\":{\"sourceid\":[\"gvrl_ref\"],\"lsr40\":[\"2010, pp.1494-1495\"],\"creatorcontrib\":[\"Apanasovich, Tatiyana V.\"],\"creationdate\":[\"2010\"],\"citation\":[\"pf 1494 pt 1495\"],\"isbn\":[\"978-1-4129-6128-8\",\"9781412961288\"],\"rsrctype\":[\"reference_entry\"],\"title\":[\"Test\"],\"startdate\":[\"20100101\"],\"recordid\":[\"gvrl_refCX1959400467\"],\"general\":[\"English\",\"Gale Virtual Reference Library (GVRL)\"],\"enddate\":[\"20101231\"],\"alttitle\":[\"Encyclopedia of Research Design\"],\"scope\":[\"gvrl_ref\",\"gale_gvrl\"]},\"display\":{\"identifier\":[\"<b>ISBN: </b>978-1-4129-6128-8\"],\"creator\":[\"Apanasovich, Tatiyana V.\"],\"ispartof\":[\"Encyclopedia of Research Design\"],\"language\":[\"eng\"],\"source\":[\"Gale Virtual Reference Library (GVRL)\"],\"title\":[\"Test\"],\"type\":[\"reference_entry\"]},\"links\":{\"openurl\":[\"$$Topenurl_article\"],\"openurlfulltext\":[\"$$Topenurlfull_article\"]},\"control\":{\"recordid\":[\"TN_gvrl_refCX1959400467\"],\"sourceid\":[\"gvrl_ref\"],\"galeid\":[\"CX1959400467\"],\"sourcerecordid\":[\"CX1959400467\"],\"sourcesystem\":[\"Other\"]},\"addata\":{\"date\":[\"2010\"],\"aulast\":[\"Apanasovich\"],\"isbn\":[\"978-1-4129-6128-8\"],\"format\":[\"journal\"],\"ristype\":[\"GEN\"],\"spage\":[\"1494\"],\"auinit\":[\"V.\"],\"atitle\":[\"Test\"],\"aufirst\":[\"Tatiyana\"],\"pages\":[\"1494-1495\"],\"au\":[\"Apanasovich, Tatiyana V.\"],\"epage\":[\"1495\"],\"genre\":[\"article\"],\"risdate\":[\"2010\"]},\"sort\":{\"creationdate\":[\"20100000\"],\"author\":[\"Apanasovich, Tatiyana V.\"],\"title\":[\"Test\"],\"lso01\":[\"20100000\"]},\"facets\":{\"frbrtype\":[\"6\"],\"creatorcontrib\":[\"Apanasovich, Tatiyana V.\"],\"creationdate\":[\"2010\"],\"frbrgroupid\":[\"-8443850069020496193\"],\"rsrctype\":[\"reference_entrys\"],\"language\":[\"eng\"],\"collection\":[\"Gale Virtual Reference Library (GVRL)\"],\"prefilter\":[\"reference_entrys\"]}},\"@id\":\"http://temple-primo.hosted.exlibrisgroup.com/primo_library/libweb/webservices/rest/primo-explore/v1/pnxs/PC/TN_gvrl_refCX1959400467\"}],\"timelog\":{\"BriefSearchDeltaTime\":366,\"DoSearchPrimoResultDeltaTime\":339,\"StartBriefSearch\":1549651046219,\"retrieveHighLightsDeltaTime\":27,\"retrieveDidUMeanDeltaTime\":27,\"GetSearchStatusDeltaTime\":339,\"StartTranslationTime\":1549651046558,\"AddSearchStatusDeltaTime\":0,\"FullEndDMDataDeltaTime\":27,\"retrieveFacetsDeltaTime\":27},\"lang3\":\"eng\",\"info\":{\"total\":1,\"last\":\"1\",\"maxTotal\":0,\"first\":\"1\"},\"facets\":[{\"values\":[{\"count\":1,\"value\":\"Apanasovich, Tatiyana V.\"}],\"name\":\"creator\"},{\"values\":[{\"count\":1,\"value\":\"eng\"}],\"name\":\"lang\"},{\"values\":[{\"count\":1,\"value\":\"reference_entrys\"}],\"name\":\"rtype\"},{\"values\":[{\"count\":1,\"value\":\"online_resources\"}],\"name\":\"tlevel\"},{\"values\":[{\"count\":1,\"value\":\"reference_entrys\"}],\"name\":\"pfilter\"},{\"values\":[{\"count\":1,\"value\":\"2010\"}],\"name\":\"creationdate\"},{\"values\":[{\"count\":1,\"value\":\"Gale Virtual Reference Library (GVRL)\"}],\"name\":\"domain\"}],\"beaconO22\":\"383\"}"
  end
end
