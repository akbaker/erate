     -- Table: analysis.nces_block_walk
      DROP TABLE analysis.nces_block_walk;
      CREATE TABLE analysis.nces_block_walk
        (
	  school_id character varying(12) primary key,
          block_fips character varying(15)
          
        )
          WITH (
          OIDS=FALSE
        );
      ALTER TABLE analysis.nces_block_walk
      OWNER TO postgres;

   copy analysis.nces_block_walk
        from '/Users/FCC/Dropbox/E-Rate/prob_model/nces_block_xwalk.csv'
        csv delimiter ',' header;
