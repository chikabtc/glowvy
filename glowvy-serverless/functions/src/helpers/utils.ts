import algoliasearch = require('algoliasearch');

const fs = require('fs');
const path = require('path');

const directoryPath = path.join(__dirname, 'files');
export function sleep(ms: any) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

export function uploadJsonFiles(db: any, file: any, fileName: String) {
  fs.readdir(directoryPath, (err: any, files: any) => {
    if (err) {
      return console.log(`Unable to scan directory: ${err}`);
    }

    file.forEach((obj: any) => {
      const { ingredients } = obj;
      delete obj.ingredients;
      // console.log(obj)
      db
        .collection(fileName)
        .add(obj)
        .then((res: any) => {
          console.log('Document written');
          // ingredients.forEach(async (objt: any) => {
          //   await res.collection('ingredients').add(objt).then(() => console.log('uploaded ingredient'));
          // });
        })
        .catch((error: any) => {
          console.error('Error adding document: ', error);
        });
    });
    return 0;
  });
}
