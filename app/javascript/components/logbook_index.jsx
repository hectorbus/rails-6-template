import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';

class Logbooks extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            isLoading: false,
            logbooks: this.props.logbooks,
            page: 2
        };

        // Binds our scroll event handler
        window.onscroll = () => {
            const {
                loadLogbooks,
                state: {
                    isLoading,
                    logbooks,
                    page
                },
            } = this;

            if (isLoading) return;

            // Checks that the page has scrolled to the bottom
            if ((window.innerHeight + document.documentElement.scrollTop + 600) >= document.documentElement.scrollHeight) {
                loadLogbooks();
            }
        };

          this.loadLogbooks = this.loadLogbooks.bind(this);
          this.renderLogbooks = this.renderLogbooks.bind(this);
          this.loading = this.loading.bind(this);
          this.logbookWithDate = this.logbookWithDate.bind(this);
          this.logbookWithoutDate = this.logbookWithoutDate.bind(this);
      }

      loading() {
          return (
              <div className="d-flex justify-content-around mt-5">
                  <div>
                    <div className="m-spinner m-spinner--brand m-spinner--sm m-2"></div>
                    <div className="m-spinner m-spinner--brand m-spinner--sm m-2"></div>
                    <div className="m-spinner m-spinner--brand m-spinner--sm m-2"></div>
                  </div>
              </div>
          );
    }

    loadLogbooks(){
        if (this.props.lastPage >= this.state.page) {
            this.setState({ isLoading : true }, () => {
                $.ajax({
                    url: '/logbooks/',
                    data: {
                        page: this.state.page
                    },
                    success: function(data) {
                        this.setState({
                          isLoading: false,
                          logbooks: [...this.state.logbooks, ...JSON.parse(data.logbooks)],
                          page: this.state.page + 1
                        });
                    }.bind(this),
                    error: function(err) {
                        this.setState({
                          isLoading: true,
                         });
                    }.bind(this)
                });
            });
        }
    }

    logbookWithDate(logbook, i) {
      return (
          <div className='m-timeline-2__item' key={ 'logbook_date_'+i }>
              <div className='custom-date'>
                <span>{ logbook.logbook_date_created[1] }</span>
              </div>
          </div>
      );
    }

    logbookWithoutDate(logbook, i) {
      return (
          <div className='m-timeline-2__item m--margin-top-30' key={ 'logbook_'+i }>
            <span className='m-timeline-2__item-time'>{ logbook.logbook_date_created[0] }</span>
              <div className='m-timeline-2__item-cricle' dangerouslySetInnerHTML={{ __html: logbook.logbook_icon }}></div>
              <div className='m-timeline-2__item-text  m--padding-top-5'>
                <div className='m-accordion m-accordion--bordered accordion-width'>
                  <div className="m-accordion__item">
                    <div className="m-accordion__item-head collapsed" role="tab" id={`m_accordion_${logbook.id}_item_1_head`} data-toggle="collapse" href={`#m_accordion_${logbook.id}_item_1_body`} aria-expanded="false">
                        <span className="m-accordion__item-title">
                          <h5 className='mb-0' dangerouslySetInnerHTML={{ __html: logbook.logbook_title }}></h5>
                        </span>

                        <span className="m-accordion__item-mode"></span>
                    </div>
                    <div className="m-accordion__item-body collapse" id={`m_accordion_${logbook.id}_item_1_body`} role="tabpanel" aria-labelledby={`m_accordion_${logbook.id}_item_1_head`} data-parent="#m_accordion_2">
                        <div className="m-accordion__item-content" dangerouslySetInnerHTML={{ __html: logbook.logbook_table }}></div>
                    </div>
                  </div>
                </div>
              </div>
          </div>
      );
    }

    renderLogbooks() {
        var dateLogbook =  this.state.logbooks[0].logbook_date_created[1]
        return (
            this.state.logbooks.map((logbook, i) =>{
                if(dateLogbook == logbook.logbook_date_created[1]){
                  if(i == 0){
                    return [this.logbookWithDate(logbook, i), this.logbookWithoutDate(logbook, i)];
                  }else{
                    return this.logbookWithoutDate(logbook, i);
                  }
                }else{
                  dateLogbook = logbook.logbook_date_created[1];
                  return [this.logbookWithDate(logbook, i), this.logbookWithoutDate(logbook, i)];
                }
            })
        );
    }

    render() {
        return (
            <main>
                <div className='m-timeline-2 m-timeline-2-custom'>
                    <div className='m-timeline-2__items'>
                      { this.renderLogbooks() }
                    </div>
                </div>
                { this.state.isLoading &&
                    this.loading()
                }
            </main>
        );
    }
}

$(document).on('turbolinks:load', function() {
    let logbooksContainer = document.getElementById('logbooks-container');
    if (logbooksContainer !== null){
        let logbooks = JSON.parse(logbooksContainer.dataset.logbooks);
        let lastPage = logbooksContainer.dataset.last_page;
        ReactDOM.render(<Logbooks logbooks={logbooks} lastPage={lastPage} />,
          logbooksContainer
        );
    }
});
