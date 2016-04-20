import codecs
import traceback
import json
import time
import sys

s = """>http://www.firearmstalk.com/
http://www.sturmgewehr.com/
http://www.gunsinternational.com/
http://www.subguns.com/
https://www.ar15.com/index.html
http://www.jncmanufacturing.com/
http://arguntrader.com/
http://www.nextechclassifieds.com/search/firearms/
http://www.thefirearmblog.com/blog/
http://www.ftfindustries.com/
http://gunchat.net/
http://www.andesource.com/177095/Web/pHomePage.aspx"""

def get_groupname(url):
    host = url.split("/")[2]    # second part
    domain = host.split(".")[-2:]  # last two parts
    return ".".join(domain)


def current_millis():
    return time.time()*1000.0

domains = map(lambda url: get_groupname(url), s.strip().split())
delay = 2000


def split(infile, outfiles):
    count = 0
    errors = 0
    t1 = current_millis()

    stats = {}
    with codecs.open(infile, 'r', encoding="utf8") as inf:
        for line in inf:
            try:
                count += 1
                doc = json.loads(line)
                group = get_groupname(doc['url'])
                bucket = other  # default bucket
                if group in outfiles:
                    bucket = outfiles[group]
                    stats[group] = stats.get(group, 0) + 1
                elif 'crawl_data' in doc and 'obj_parents' in doc['crawl_data']:
                    parents = doc["crawl_data"]["obj_parents"]
                    if parents:
                        for p in parents:
                            pgroup = get_groupname(p)
                            if pgroup in outfiles:
                                bucket = outfiles[pgroup]  # parents bucket
                                stats[pgroup] = stats.get(pgroup, 0) + 1
                                break
                bucket.write(json.dumps(doc))
                bucket.write("\n")
            except Exception:
                errors += 1
                traceback.print_exc()
            if current_millis() - t1 > delay:
                print("Count = {0}, Skipped={1} \n Stats:{2}".format(count, errors, stats))
                t1 = current_millis()

        print("Count = {0}, Skipped={1}\n Stats:{2}".format(count, errors, stats))
        print("All done")


if __name__ == '__main__':

    if len(sys.argv) != 3:
        print("Expected 2 args, but given %d" % (len(sys.argv) - 1))
        print("Invalid Args. Usage:: <in.json> <out-dir>")
        sys.exit(1)
    infile = sys.argv[1]
    outdir = sys.argv[2]
    files = {}
    for d in domains:
        files[d] = codecs.open("{0}/{1}-NASAJPL.json".format(outdir, d.upper()), 'w', encoding='utf8')
    other = codecs.open("{0}/{1}-NASAJPL.json".format(outdir, "OTHERS"), 'w', encoding="utf8")
    files["other"] = other
    try:
        split(infile, files)
    except Exception as e:
        print(e)
        traceback.print_exc()
    for k, v in files.items():
        try:
            v.close()
        except:
            traceback.print_exc()

